# GIS Dashboard - AI Coding Instructions

## Architecture Overview

This Flutter app visualizes Bangladesh vaccination data using a **hierarchical drilldown GIS system** with clean architecture patterns. Key architectural decisions:

- **Feature-driven structure**: `lib/features/{map,filter,summary,epi_center}/` with domain-data-presentation layers
- **Riverpod state management**: All state via providers (`StateNotifierProvider`, `Provider`)
- **Code generation workflow**: Freezed + json_serializable for immutable models with `.freezed.dart/.g.dart` files
- **Hierarchical navigation**: Country → Division → District → Upazila with dynamic URL paths and caching strategy

## Critical Development Workflows

### Code Generation (Essential)

Always run after model changes or git pulls:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Generated files (`.freezed.dart`, `.g.dart`) are gitignored - regenerate locally.

### Project Structure Patterns

- **Features**: Follow `domain/` (models), `data/` (repositories), `presentation/` (controllers/widgets)
- **State controllers**: Use `StateNotifierProvider` pattern with separate state classes
- **Exports**: Each feature has a barrel file (e.g., `lib/features/filter/filter.dart`)

## Domain Modeling

### Data Models with Freezed

All API models use this pattern:

```dart
@freezed
abstract class ModelName with _$ModelName {
  const factory ModelName({
    @JsonKey(name: 'api_field') String? field,
  }) = _ModelName;

  factory ModelName.fromJson(Map<String, dynamic> json) =>
    _$ModelNameFromJson(json);
}
```

### Hierarchical Navigation State

The app implements **drilldown levels** for geographic navigation:

- `DrilldownLevel` class manages current geographic context (country/division/district/upazila)
- URL paths are dynamic: `/shapes/{slug}/shape.json.gz`, `/coverage/{slug}/{year}-coverage.json`
- Each level has corresponding slug patterns (`dhaka-district`, `tahirpur-upazila`)

## State Management Patterns

### Provider Architecture

Controllers follow this structure:

```dart
final controllerProvider = StateNotifierProvider<Controller, State>((ref) {
  return Controller(
    repository: ref.read(repositoryProvider),
    // Cross-feature dependencies via ref.read()
  );
});
```

### Data Service Pattern

`lib/core/service/data_service.dart` implements:

- **Unified caching** across map/summary features
- **Retry logic** with exponential backoff
- **Cache invalidation** based on year/area changes

## GIS-Specific Implementation

### Map Integration

- **flutter_map** + **flutter_map_geojson** for rendering
- **GeoJSON + coverage data correlation** via geographic slugs
- **Color-coded coverage visualization** using `CoverageColors.getCoverageColor()`

### Geographic Data Flow

1. Load GeoJSON shapes (`/shapes/{slug}/shape.json.gz`)
2. Fetch coverage data (`/coverage/{slug}/{year}-coverage.json`)
3. Correlate by geographic identifiers in both datasets
4. Apply color mapping based on vaccination coverage percentages

## Environment & Configuration

### Environment Setup

- `.env` file required with API endpoints (`STAGING_SERVER_URL`, etc.)
- `ApiConstants` class generates dynamic paths using dotenv values
- Constants defined in `lib/core/common/constants/`

### Year-based Data Handling

- Coverage data is year-specific (`2024-coverage.json`, `2025-coverage.json`)
- Filter state manages year selection affecting all data requests
- Cached data includes year validation for accuracy

## Network & Error Handling

### API Client Setup

- **Dio client** with base URL, timeouts, and logging interceptor
- Provider-based dependency injection for repositories
- Retry logic in `DataService` with different strategies for GeoJSON vs coverage data

### Error Patterns

- Network errors handled in `NetworkErrorHandler`
- Connectivity checking via `connectivity_plus`
- Graceful fallbacks with cached data when network fails

## Testing Strategy

- Widget tests in `test/` directory
- Repository layer mocking for unit tests
- Integration testing for map rendering and data correlation

## Key Integration Points

- **Cross-feature communication**: Filter changes trigger map/summary updates via shared providers
- **Data synchronization**: `DataService` ensures consistent state across features
- **Geographic correlation**: Slug-based matching between GeoJSON shapes and coverage data
- **Cache coordination**: Year/area changes invalidate relevant cached data only

When modifying geographic navigation, ensure URL path generation in `ApiConstants` matches backend structure. When adding new data models, follow the Freezed + json_annotation pattern and run code generation.
