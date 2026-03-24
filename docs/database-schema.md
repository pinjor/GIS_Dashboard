# Database Schema Documentation

## Overview

The GIS Dashboard application primarily uses **remote API data** and does not maintain a local database for geographic or vaccination data. However, the application uses **SQLite** (via `sqflite` package) for local caching and offline capabilities.

## Local Database (SQLite)

### Purpose

- Cache frequently accessed data
- Offline data storage
- User preferences
- Session data

### Schema

The database schema is managed by the `sqflite` package. Currently, the application does not implement extensive local database usage, but the infrastructure is in place.

### Future Enhancements

Potential local database tables:

1. **Cached Coverage Data**
   - Area UID
   - Year
   - Coverage JSON
   - Timestamp

2. **Cached GeoJSON**
   - Area slug
   - GeoJSON data
   - Timestamp

3. **User Preferences**
   - Selected filters
   - Map settings
   - Display preferences

## Remote Data Structure

### Geographic Hierarchy

The application works with a hierarchical geographic structure:

```
Country (Bangladesh)
├── Division
│   ├── District
│   │   ├── Upazila
│   │   │   ├── Union
│   │   │   │   ├── Ward
│   │   │   │   │   └── Subblock
│   │   │   │   └── EPI Centers
│   │   │   └── EPI Centers
│   │   └── EPI Centers
│   └── EPI Centers
└── City Corporation
    ├── Zone
    │   └── Ward
    │       └── EPI Centers
    └── EPI Centers
```

### Data Models

#### Area Response Model

```dart
{
  "uid": "string",
  "name": "string",
  "type": "string"
}
```

#### Coverage Response

```json
{
  "vaccines": [
    {
      "vaccine_uid": "string",
      "vaccine_name": "string",
      "total_target": 0,
      "total_target_male": 0,
      "total_target_female": 0,
      "total_coverage": 0,
      "total_coverage_male": 0,
      "total_coverage_female": 0,
      "areas": [
        {
          "area_uid": "string",
          "area_name": "string",
          "target_male": 0,
          "target_female": 0,
          "coverage_male": 0,
          "coverage_female": 0
        }
      ]
    }
  ]
}
```

#### EPI Center Response

```json
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [longitude, latitude]
      },
      "info": {
        "name": "string",
        "org_uid": "string",
        "type_name": "string",
        "is_fixed_center": boolean
      }
    }
  ]
}
```

#### Session Plan Response

```json
{
  "type": "FeatureCollection",
  "session_count": 0,
  "features": [
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [longitude, latitude]
      },
      "info": {
        "name": "string",
        "org_uid": "string",
        "type_name": "string",
        "is_fixed_center": boolean
      },
      "session_dates": "YYYY-MM-DD,YYYY-MM-DD"
    }
  ]
}
```

## Data Relationships

### Geographic Relationships

- **One-to-Many**: Each area has multiple child areas
- **Many-to-One**: Each area belongs to one parent area
- **Many-to-Many**: EPI centers can serve multiple areas

### Coverage Relationships

- **One-to-Many**: One area has multiple vaccine coverage records
- **One-to-Many**: One vaccine has coverage in multiple areas

## Data Flow

1. **Initial Load**: Fetch country-level data
2. **Drilldown**: Load child areas on demand
3. **Filtering**: Filter data based on user selections
4. **Caching**: Cache frequently accessed data locally

## Data Validation

- **UID Validation**: All UIDs must be non-empty strings
- **Coordinate Validation**: Lat/Lng must be within valid ranges
- **Date Validation**: Dates must be in `YYYY-MM-DD` format
- **Null Safety**: All nullable fields are properly handled

## Data Synchronization

- **Real-time**: Data fetched from API on demand
- **Caching**: Frequently accessed data cached locally
- **Offline**: Limited offline support (future enhancement)

## Performance Considerations

- **Compression**: GeoJSON files compressed with GZip
- **Lazy Loading**: Child areas loaded only when needed
- **Pagination**: Large datasets paginated (if API supports)
- **Caching Strategy**: Cache with TTL (Time To Live)

## Future Enhancements

1. **Offline Database**: Full offline support with local database
2. **Data Sync**: Background sync for offline data
3. **Conflict Resolution**: Handle data conflicts when syncing
4. **Data Compression**: Further optimize data storage
