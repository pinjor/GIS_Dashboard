# API Documentation

## Base URLs

### Staging
- **Full URL**: `https://staging.gisdashboard.online`
- **API Path**: `/api/v1`
- **Storage Path**: `/storage/build-json`

### Production
- Configured via `.env` file

## Authentication

Currently, the API does not require authentication. All endpoints are publicly accessible.

## API Endpoints

### Geographic Data

#### Get GeoJSON Shapes

**Endpoint**: `/shapes/{slug}/shape.json.gz`

**Method**: `GET`

**Description**: Returns compressed GeoJSON data for a specific geographic area.

**Parameters**:
- `slug` (path): Geographic area slug (e.g., `dhaka-district`, `tahirpur-upazila`)

**Response**: Compressed GeoJSON file (GZip)

**Examples**:
```
GET /shapes/dhaka-district/shape.json.gz
GET /shapes/divisions/barishal-division/shape.json.gz
GET /shapes/city-corporations/shape.json.gz
```

#### Get Coverage Data

**Endpoint**: `/coverage/{slug}/{year}-coverage.json`

**Method**: `GET`

**Description**: Returns vaccination coverage data for a specific area and year.

**Parameters**:
- `slug` (path, optional): Geographic area slug
- `year` (path): Year (e.g., `2024`, `2025`)

**Response**: JSON object with coverage data

**Examples**:
```
GET /coverage/2025-coverage.json                    # Country level
GET /coverage/dhaka-district/2025-coverage.json     # District level
GET /coverage/divisions/barishal-division/2025-coverage.json
```

### EPI Centers

#### Get EPI Center Coordinates

**Endpoint**: `/epi/{slug}/epi.json`

**Method**: `GET`

**Description**: Returns EPI center coordinates for a specific area.

**Parameters**:
- `slug` (path, optional): Geographic area slug

**Response**: GeoJSON FeatureCollection with Point geometries

**Examples**:
```
GET /epi/epi.json                           # Country level
GET /epi/dhaka-district/epi.json            # District level
```

#### Get EPI Center Details

**Endpoint**: `/chart/{orgUid}?year={year}&request-from=app`

**Method**: `GET`

**Description**: Returns detailed information for a specific EPI center.

**Parameters**:
- `orgUid` (path): Organization UID of the EPI center
- `year` (query): Year (e.g., `2025`)
- `request-from` (query): Always `app`

**Response**: JSON object with EPI center details

**Example**:
```
GET /chart/UQ7up0ejmVn?year=2025&request-from=app
```

### Session Plans

#### Get Session Plans

**Endpoint**: `/session-plans`

**Method**: `GET`

**Description**: Returns session plan coordinates for vaccination sessions.

**Query Parameters**:
- `area` (optional): Area UID or concatenated path (e.g., `district_uid/upazila_uid`)
- `start_date` (required): Start date in `YYYY-MM-DD` format
- `end_date` (required): End date in `YYYY-MM-DD` format
- `limit` (optional): Maximum number of features to return (default: varies)

**Response**: GeoJSON FeatureCollection with session plan markers

**Example**:
```
GET /session-plans?area=qctlb4zamgb/wfn5xpxfi4k&start_date=2025-12-01&end_date=2025-12-31&limit=50000
```

**Response Structure**:
```json
{
  "type": "FeatureCollection",
  "session_count": 150,
  "features": [
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [90.3563, 23.6850]
      },
      "info": {
        "name": "EPI Center Name",
        "org_uid": "UQ7up0ejmVn",
        "type_name": "Fixed Center",
        "is_fixed_center": true
      },
      "session_dates": "2025-12-01,2025-12-15"
    }
  ]
}
```

### Area Hierarchy

#### Get Areas

**Endpoint**: `/areas`

**Method**: `GET`

**Description**: Returns area hierarchy data (divisions, districts, etc.).

**Response**: JSON array of area objects

**Example**:
```
GET /areas
```

#### Get Child Data

**Endpoint**: `/get/{type}/child-data`

**Method**: `GET`

**Description**: Returns child areas for a specific area type.

**Parameters**:
- `type` (path): Area type (e.g., `zones`, `wards`)

**Example**:
```
GET /get/zones/child-data
```

## Error Responses

### Standard Error Format

```json
{
  "error": "Error message",
  "code": "ERROR_CODE"
}
```

### HTTP Status Codes

- `200 OK`: Successful request
- `400 Bad Request`: Invalid parameters
- `404 Not Found`: Resource not found
- `500 Internal Server Error`: Server error

## Rate Limiting

Currently, no rate limiting is implemented. However, clients should implement reasonable request throttling.

## Data Formats

### GeoJSON

All geographic data is returned in GeoJSON format:

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
      "properties": {
        // Feature properties
      }
    }
  ]
}
```

### Compression

GeoJSON shape files are compressed using GZip (.json.gz). Clients must decompress before parsing.

## Best Practices

1. **Caching**: Cache responses when appropriate to reduce server load
2. **Error Handling**: Always handle network errors gracefully
3. **Retry Logic**: Implement retry logic for failed requests
4. **Date Formats**: Always use `YYYY-MM-DD` format for dates
5. **Slug Format**: Convert area names to lowercase slugs with hyphens

## Testing

API endpoints can be tested using:
- Postman
- cURL
- Browser (for GET requests)

**Example cURL**:
```bash
curl "https://staging.gisdashboard.online/api/v1/session-plans?start_date=2025-12-01&end_date=2025-12-31"
```
