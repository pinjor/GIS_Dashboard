# GIS Dashboard - AI Coding Instructions

## Architecture Overview

This Flutter app visualizes Bangladesh vaccination data using a **hierarchical drilldown GIS system** with clean architecture prioritizing geographic synchronization and state management.

**Core Stack**: Flutter 3.8.1+ | Riverpod state management | Freezed/json_serializable code generation | flutter_map + GeoJSON rendering

**Key Patterns**:
- **Feature-driven structure**: `lib/features/{map,filter,summary,epi_center,zero_dose_dashboard,micro_plan,session_plan,gis_methodology,home}/` with domain-data-presentation layers
- **Cross-provider dependencies**: Controllers directly injected as constructor params (MapController receives FilterController)
- **Hierarchical drilldown**: Country → Division → District → Upazila with dynamic slug-based paths
- **GeoJSON decompression**: Map data fetched as `.json.gz`, decompressed via `archive` package
- **Graceful degradation**: Area data (divisions/districts/city corps) load independently—partial data preferred over total failure

## Critical Development Workflows

### Code Generation (Essential)

**Always run after model changes or git pulls** - generated files are gitignored:

```bash
dart run build_runner build --delete-conflicting-outputs
```

All `@freezed` models require `.freezed.dart` + `.g.dart` files. Missing these causes compilation errors.

### Environment Configuration

Create `.env` file at project root with:
```
STAGING_SERVER_URL=https://api.example.com
STAGING_SERVER_HOST=api.example.com
URL_SCHEME=https
URL_COMMON_PATH=/api/v1
```

Access via `ApiConstants` class: `ApiConstants.stagingServerFullUrl`, `ApiConstants.urlCommonPath`

## State Management Architecture

### Cross-Provider Dependencies (Critical Pattern)

Controllers are **directly injected** to enable bidirectional communication:

```dart
// MapController receives FilterController as constructor param
MapControllerNotifier({
  required DataService dataService,
  required FilterControllerNotifier filterNotifier, // Direct injection
}) : _filterNotifier = filterNotifier;

// Map can update filter state
_filterNotifier.updateDivision(divisionName);
_filterNotifier.updateDistrict(districtName);
```

**Why**: Filter changes must trigger map updates AND map interactions must update filters (e.g., clicking district polygon updates filter dropdown).

### Provider Lifecycle & Cleanup

```dart
final filterControllerProvider = StateNotifierProvider<FilterControllerNotifier, FilterState>((ref) {
  final controller = FilterControllerNotifier(repository: repository, ref: ref);
  
  ref.onDispose(() {
    controller.clearEpiDetailsContext(); // Restore original filter state
  });
  
  return controller;
});
```

**Critical**: `clearEpiDetailsContext()` must run when navigating away from EPI screens to restore cached filter selections.

### Post-Frame Callbacks for State Changes

```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  if (mounted) {
    ref.read(mapControllerProvider.notifier).loadDistrictData(districtName: district);
  }
});
```

**When**: Use when filter changes need UI to settle before triggering map reloads. Prevents "setState during build" errors.

## Data Flow & Network Patterns

### GeoJSON Decompression Pipeline

All map shapes come as `.json.gz` files - `MapRepository` handles decompression:

```dart
final response = await _client.get(urlPath, 
  options: Options(responseType: ResponseType.bytes, receiveTimeout: Duration(seconds: 300))
);
final archive = GZipDecoder().decodeBytes(response.data as List<int>);
final jsonString = String.fromCharCodes(archive);
return AreaCoordsGeoJsonResponse.fromJson(jsonDecode(jsonString));
```

**URL Pattern**: `/shapes/{slug}/shape.json.gz` where slug = `dhaka-district`, `tahirpur-upazila`, etc.

### Repository Pattern with Connectivity Checks

**All** repository methods check internet before API calls:

```dart
Future<List<Model>> fetchData() async {
  if (!await _connectivityService.hasInternetConnection()) {
    throw NetworkException(message: 'No internet connection', type: NetworkErrorType.noInternet);
  }
  
  final response = await _client.get(url);
  return (response.data as List).map((json) => Model.fromJson(json)).toList();
}
```

**Important**: `hasInternetConnection()` uses `InternetAddress.lookup('google.com')` with 5s timeout - can block UI thread if not handled carefully.

### Parallel API Loading Anti-Pattern ⚠️

**AVOID** `Future.wait()` for critical flows - single failure blocks all data loading:

```dart
// ❌ BAD: Fail-fast behavior - if divisions fails, districts never load
final results = await Future.wait([
  fetchDivisions(),
  fetchDistricts(), 
  fetchCityCorporations(),
]);

// ✅ GOOD: Individual try-catch with graceful degradation
// From FilterController._loadAllAreas() in lib/features/filter/presentation/controllers/filter_controller.dart
bool hasAnySuccess = false;
List<String> failedTypes = [];

// Load divisions independently
try {
  divisions = await _repository.fetchAllDivisions();
  hasAnySuccess = true;
} catch (e) {
  logg.e('Failed to load divisions: $e');
  failedTypes.add('divisions');
}

// Load districts independently
try {
  districts = await _repository.fetchAllDistricts();
  hasAnySuccess = true;
} catch (e) {
  logg.e('Failed to load districts: $e');
  failedTypes.add('districts');
}

// Update state with whatever loaded successfully
state = state.copyWith(
  divisions: divisions,
  districts: districts,
  areasError: hasAnySuccess ? (failedTypes.isEmpty ? null : 'Partial load: ${failedTypes.join(", ")} failed') 
                            : 'All data failed to load',
);
```

**Why**: FilterController initially used `Future.wait()`, causing division API failures to freeze the entire filter system. Individual loading allows partial data to work while retrying failed requests.

### DataService Retry Logic

`lib/core/service/data_service.dart` wraps repositories with exponential backoff:

```dart
for (int attempt = 1; attempt <= 3; attempt++) {
  try {
    return await _mapRepository.fetchAreaGeoJsonCoordsData(urlPath: urlPath);
  } catch (e) {
    if (attempt < 3) {
      await Future.delayed(Duration(milliseconds: 1000 * attempt)); // 1s, 2s, 3s
      continue;
    }
    throw e;
  }
}
```

**Note**: GeoJSON gets longer delays (1-3s) than coverage data due to larger file sizes.

## Geographic Navigation & Filter Synchronization

### Hierarchical Drilldown System

Navigation follows: **Country → Division → District → Upazila → Union → Ward**

`DrilldownLevel` tracks context with slugs:
- Division: `barishal-division`
- District: `dhaka-district`  
- Upazila: `tahirpur-upazila`

Dynamic API paths generated by `ApiConstants`:
```dart
// GeoJSON shapes
ApiConstants.getGeoJsonPath(slug: 'dhaka-district') 
// → '/shapes/dhaka-district/shape.json.gz'

// Coverage data (year-specific)
ApiConstants.getCoveragePath(slug: 'dhaka-district', year: '2025')
// → '/coverage/dhaka-district/2025-coverage.json'
```

### Filter-Map Bidirectional Sync

**Map → Filter**: Clicking district polygon updates filter dropdowns:

```dart
// In map tap handler
if (mapController.isDistrictUid(areaId)) {
  mapController.syncFiltersWithDistrict(areaId); // Updates FilterController state
}
```

**Filter → Map**: Filter changes trigger map reloads via listener in `MapScreen`:

```dart
ref.listen<FilterState>(filterControllerProvider, (previous, current) {
  if (districtFilterApplied) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapControllerProvider.notifier).loadDistrictData(districtName: district);
    });
  }
});
```

### EPI Context Management (Critical)

When entering EPI details screens, filter controller **caches** original state:

```dart
void updateForEpiDetailsContext(EpiCenterDetailsResponse epiData, String? ccUid) {
  // Detect if entering different CC context
  if (shouldUpdateCcContext) {
    state = state.copyWith(
      shouldLoadCcContext: true,
      originalCachedCcUid: state.selectedCityCorporation, // Cache current selection
    );
  }
}
```

**On exit**, restore original state:

```dart
void clearEpiDetailsContext() {
  state = state.copyWith(
    isEpiDetailsContext: false,
    clearOriginalEpiUid: true, // Triggers restoration of cached values
  );
}
```

**Why**: EPI screens modify filters temporarily (e.g., auto-select specific upazila). Without caching, users lose their original filter selections when navigating back.

## Key Integration Points

- **Cross-feature communication**: Filter changes trigger map/summary updates via shared providers
- **Data synchronization**: `DataService` ensures consistent state across features  
- **Geographic correlation**: Slug-based matching between GeoJSON shapes and coverage data
- **Cache coordination**: Year/area changes invalidate relevant cached data only
- **EPI context isolation**: Filter state preserves original values when entering/exiting EPI screens

## Development Debugging

### Logging Pattern

Use the global `logg` instance (imported from `lib/core/utils/utils.dart`) for consistent logging:

```dart
import 'package:gis_dashboard/core/utils/utils.dart';

logg.i("✅ Successfully loaded data");
logg.e("❌ Error occurred: $error"); 
logg.d("🔍 Debug info: $details");
logg.w("⚠️ Warning: $message");
```

The logger is configured globally and integrates with the app's debugging infrastructure.

### Common Issues & Solutions

| Issue | Root Cause | Solution |
|-------|-----------|----------|
| Filter button disabled | Check `_isFilterButtonEnabled()` logic in `FilterDialogBoxWidget` | Ensure all required filters have non-null values |
| EPI context stale data | `clearEpiDetailsContext()` not called on navigation | Call in route pop handler: `ref.read(filterControllerProvider.notifier).clearEpiDetailsContext()` |
| Division loading fails silently | Previous `Future.wait()` pattern in `_loadAllAreas()` | Already fixed with individual try-catch (preserve pattern) |
| Map doesn't update on filter change | Listener in `MapScreen` not triggering | Check `ref.listen<FilterState>(filterControllerProvider, ...)` is properly connected |
| ".freezed.dart files not found" | Generated files missing | Run: `dart run build_runner build --delete-conflicting-outputs` |

When modifying geographic navigation, ensure URL path generation in `ApiConstants` matches backend structure. When adding new data models, follow the Freezed + json_annotation pattern and run code generation.

## Critical Implementation Notes

### Environment Configuration & API Paths

Create `.env` file at project root:
```
URL_SCHEME=https
STAGING_SERVER_HOST=api.example.com
STAGING_SERVER_FULL_URL=https://api.example.com
URL_COMMON_PATH=/api/v1
```

Dynamic path generation in `ApiConstants`:
- **GeoJSON shapes**: `getGeoJsonPath(slug)` → `/shapes/{slug}/shape.json.gz`
- **Coverage data**: `getCoveragePath(slug, year)` → `/coverage/{slug}/{year}-coverage.json`
- **EPI centers**: `getEpiPath(slug)` → `/epi/{slug}/epi.json`

All slug values are converted to lowercase automatically.

### Filter State Provider Lifecycle

The `filterControllerProvider` explicitly cleans up EPI context on dispose:

```dart
ref.onDispose(() {
  controller.clearEpiDetailsContext(); // Restore original filter state
});
```

**Critical**: This prevents stale filter state when navigating between screens.

### Data Service Retry Logic

`lib/core/service/data_service.dart` wraps all repository calls with 3-attempt exponential backoff:
- Coverage data: 500ms, 1000ms, 1500ms delays
- GeoJSON data: Same pattern (files larger, same retry strategy)

**Do NOT** wrap these in additional retry logic—it's already handled transparently.

### Connectivity Service Pattern

All repository methods check internet before API calls:

```dart
if (!await _connectivityService.hasInternetConnection()) {
  throw NetworkException(message: 'No internet connection', type: NetworkErrorType.noInternet);
}
```

**Note**: `hasInternetConnection()` uses `InternetAddress.lookup('google.com')` with 5s timeout.
