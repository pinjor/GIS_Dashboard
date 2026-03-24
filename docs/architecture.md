# Architecture Documentation

## Overview

The GIS Dashboard is a Flutter application built using **Clean Architecture** principles with a feature-driven structure. The application visualizes vaccination data of Bangladesh using geographic information systems (GIS).

## Architecture Pattern

### Clean Architecture Layers

```
lib/
├── core/              # Shared utilities, network, services
│   ├── common/        # Constants, widgets, screens
│   ├── network/       # HTTP client, interceptors, error handling
│   ├── service/       # Data service layer
│   └── utils/         # Utility functions
│
├── features/          # Feature modules (domain-data-presentation)
│   ├── map/           # Interactive GIS map
│   ├── filter/        # Filtering system
│   ├── summary/       # Statistical dashboard
│   ├── epi_center/    # EPI center details
│   ├── session_plan/  # Session planning
│   ├── epi_center_finder/  # EPI Center Finder (location-based search)
│   └── ...
│
└── main.dart          # Application entry point
```

### Feature Structure

Each feature follows a consistent structure:

```
feature_name/
├── data/              # Data layer
│   └── repository.dart
├── domain/             # Domain layer
│   ├── models/        # Domain models
│   └── state.dart     # State classes
└── presentation/      # Presentation layer
    ├── controllers/   # State management
    ├── screens/       # UI screens
    └── widgets/       # Reusable widgets
```

## State Management

### Riverpod

The application uses **Riverpod 2.6.1** for state management:

- **StateNotifierProvider**: For complex state management
- **Provider**: For dependency injection and simple state
- **Cross-Provider Dependencies**: Direct injection pattern

### State Synchronization

- **Bidirectional Sync**: Filter changes update map, map interactions update filter
- **EPI Context**: Special mode that preserves original filter state during navigation
- **State Lifecycle**: Proper initialization, updates, and cleanup

## Data Flow

### Network Layer

```
User Action
  ↓
Controller (StateNotifier)
  ↓
Repository
  ↓
DataService (with retry logic)
  ↓
Dio HTTP Client
  ↓
API Server
  ↓
Response Processing
  ↓
State Update
  ↓
UI Rebuild
```

### Data Formats

- **GeoJSON**: Compressed with GZip (.json.gz)
- **Coverage Data**: JSON with hierarchical structure
- **EPI Data**: GeoJSON FeatureCollection with Point geometries

## Key Design Patterns

1. **Repository Pattern**: Data abstraction layer
2. **Provider Pattern**: Dependency injection via Riverpod
3. **Observer Pattern**: State watching/listening
4. **Strategy Pattern**: Dynamic URL generation for different area types
5. **Factory Pattern**: Code generation for models (Freezed)

## Geographic Hierarchy

The application supports hierarchical drilldown:

```
Country
  ↓
Division
  ↓
District
  ↓
Upazila
  ↓
Union
  ↓
Ward
  ↓
Subblock
```

**Special Handling:**
- City Corporations: CC → Zone → Ward
- EPI Centers: Fixed vs Mobile centers

## Code Generation

The project uses code generation for type-safe models:

- **Freezed**: Immutable models with union types
- **json_serializable**: JSON serialization
- **build_runner**: Code generation tool

**Generated Files:**
- `*.freezed.dart`: Immutable state classes
- `*.g.dart`: JSON serialization code

## Error Handling

- **Network Errors**: Connectivity checks, retry logic, user-friendly messages
- **Data Errors**: Null safety, fallback strategies, graceful degradation
- **UI Error States**: Loading widgets, error widgets, empty states

## Performance Considerations

- **GeoJSON Compression**: GZip compression reduces file size
- **Lazy Loading**: Areas loaded on demand
- **State Caching**: Filter state preserved during navigation
- **Marker Limiting**: Prevents crashes on low-end devices

## Security

- **Environment Variables**: Sensitive config in .env (gitignored)
- **SSL**: Certificate validation (bypassed only for staging in debug)
- **Network Security**: HTTPS only

## Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ Linux
- ✅ macOS
