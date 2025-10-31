# GIS Dashboard - AI Coding Instructions

## Architecture Overview

This Flutter app visualizes Bangladesh vaccination data using a **hierarchical drilldown GIS system** with clean architecture. The architecture prioritizes geographic data synchronization and state management across features.

**Core Stack**: Flutter 3.8.1+ | Riverpod state management | Freezed/json_serializable code generation | flutter_map + GeoJSON rendering

**Key Patterns**:
- **Feature-driven structure**: `lib/features/{map,filter,summary,epi_center}/` with domain-data-presentation layers
- **Cross-provider dependencies**: Controllers inject each other via constructor parameters (MapController ← FilterController)
- **Hierarchical navigation**: Country → Division → District → Upazila with dynamic slug-based URL paths
- **GeoJSON decompression**: All map data fetched as `.json.gz` files, decompressed using `archive` package

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

**AVOID** `Future.wait()` for critical flows - single failure blocks all data:

```dart
// ❌ BAD: Fail-fast behavior - if divisions fails, districts never load
final results = await Future.wait([
  fetchDivisions(),
  fetchDistricts(), 
  fetchCityCorporations(),
]);

// ✅ GOOD: Individual error handling with graceful degradation
try { state = state.copyWith(divisions: await fetchDivisions()); } catch (e) { 
  logg.e('Failed to load divisions: $e');
  state = state.copyWith(areasError: 'Failed to load divisions');
}
try { state = state.copyWith(districts: await fetchDistricts()); } catch (e) { /* handle */ }
```

**Why**: `FilterController._loadAllAreas()` had issues where division API failures froze entire filter system. Separate try-catch allows partial data loading.

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

Use the global `logg` instance for consistent logging:

```dart
import 'package:gis_dashboard/core/utils/utils.dart';

logg.i("✅ Successfully loaded data");
logg.e("❌ Error occurred: $error"); 
logg.d("🔍 Debug info: $details");
```

### Common Issues

1. **Filter button disabled**: Check `_isFilterButtonEnabled()` logic in `FilterDialogBoxWidget` 
2. **EPI context stale data**: Ensure `clearEpiDetailsContext()` is called when navigating away
3. **Division loading failures**: Look for `Future.wait()` usage and replace with individual error handling

When modifying geographic navigation, ensure URL path generation in `ApiConstants` matches backend structure. When adding new data models, follow the Freezed + json_annotation pattern and run code generation.
