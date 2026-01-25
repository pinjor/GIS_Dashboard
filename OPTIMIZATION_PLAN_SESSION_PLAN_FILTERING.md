# Session Plan Date Filtering Optimization Plan

## Problem Statement
Filtering with date range (e.g., December 1-31, 2025) takes too much time. The loading process is slow and needs optimization without changing other functionalities.

## Current Bottlenecks Identified

### 1. **Unnecessary GeoJSON Reloading** ⚠️ HIGH IMPACT
- **Issue**: GeoJSON is reloaded even when only dates change (area remains the same)
- **Location**: `session_plan_controller.dart` line 155-239
- **Impact**: Adds 2-5 seconds per filter change
- **Current Behavior**: Always checks/loads GeoJSON even if area hasn't changed

### 2. **Sequential Data Loading** ⚠️ HIGH IMPACT
- **Issue**: GeoJSON and session plan data load sequentially instead of in parallel
- **Location**: `session_plan_controller.dart` line 155-246
- **Impact**: Doubles the loading time
- **Current Behavior**: Waits for GeoJSON before fetching session plan data

### 3. **No Caching for Session Plan Data** ⚠️ MEDIUM IMPACT
- **Issue**: `forceRefresh: true` always bypasses cache
- **Location**: `session_plan_controller.dart` line 245
- **Impact**: Every date filter change triggers new API call
- **Current Behavior**: Always fetches fresh data, no cache utilization

### 4. **Unnecessary Map Drilldown on Date Changes** ⚠️ MEDIUM IMPACT
- **Issue**: Map drilldown is triggered even when only dates change
- **Location**: `session_plan_screen.dart` line 400-550
- **Impact**: Adds 1-3 seconds of unnecessary map operations
- **Current Behavior**: Filter listener doesn't distinguish date-only changes

### 5. **Multiple Delays and Wait Times** ⚠️ LOW-MEDIUM IMPACT
- **Issue**: Multiple `Future.delayed` calls add up
- **Location**: 
  - `session_plan_filter_dialog.dart` line 254 (200ms)
  - `session_plan_screen.dart` line 509 (up to 3000ms for upazilas)
- **Impact**: Adds 200ms-3000ms of artificial delays
- **Current Behavior**: Conservative waiting for async operations

### 6. **No Request Timeout Optimization** ⚠️ LOW IMPACT
- **Issue**: Default timeout might be too long for session plan API
- **Location**: `dio_client_provider.dart` line 29 (30 seconds)
- **Impact**: Slow API responses take longer to fail
- **Current Behavior**: 30-second timeout for all requests

## Optimization Solutions

### ✅ Solution 1: Skip GeoJSON Reload When Only Dates Change (HIGH PRIORITY)
**File**: `lib/features/session_plan/presentation/controllers/session_plan_controller.dart`

**Changes**:
1. Add a check to compare current area UID with previous area UID
2. Only reload GeoJSON if area has changed
3. Reuse existing GeoJSON from map controller or previous state if area is unchanged

**Implementation**:
```dart
// In loadDataWithFilter method, before GeoJSON loading:
final previousAreaUid = state.areaCoordsGeoJsonData != null 
    ? _getAreaUidFromState() 
    : null;
final currentAreaUid = effectiveAreaUid;

// Only reload GeoJSON if area changed
if (previousAreaUid != currentAreaUid) {
  // Load GeoJSON (existing logic)
} else {
  // Reuse existing GeoJSON
  areaCoordsGeoJsonData = state.areaCoordsGeoJsonData;
  logg.i("Session Plan: Reusing existing GeoJSON (area unchanged)");
}
```

**Expected Improvement**: 2-5 seconds saved per date filter change

---

### ✅ Solution 2: Parallel Loading of GeoJSON and Session Plan Data (HIGH PRIORITY)
**File**: `lib/features/session_plan/presentation/controllers/session_plan_controller.dart`

**Changes**:
1. Load GeoJSON and session plan data in parallel using `Future.wait`
2. Only wait for session plan data if GeoJSON is not already available

**Implementation**:
```dart
// Load both in parallel if GeoJSON needs to be fetched
if (mapState.areaCoordsGeoJsonData == null) {
  final results = await Future.wait([
    _dataService.fetchAreaGeoJsonCoordsData(...),
    _dataService.getSessionPlanCoords(...),
  ]);
  areaCoordsGeoJsonData = results[0];
  sessionPlanCoordsData = results[1];
} else {
  // GeoJSON already available, only fetch session plan
  sessionPlanCoordsData = await _dataService.getSessionPlanCoords(...);
  areaCoordsGeoJsonData = mapState.areaCoordsGeoJsonData;
}
```

**Expected Improvement**: 1-3 seconds saved (50% reduction in sequential wait time)

---

### ✅ Solution 3: Smart Caching for Session Plan Data (MEDIUM PRIORITY)
**File**: `lib/features/session_plan/presentation/controllers/session_plan_controller.dart`

**Changes**:
1. Change `forceRefresh: true` to `forceRefresh: false` for date-only changes
2. Add cache key based on area + date range
3. Only force refresh when area changes

**Implementation**:
```dart
// Determine if we should force refresh
final shouldForceRefresh = areaUid != null && 
    areaUid != _getPreviousAreaUid() ||
    geoJsonPath != null;

final sessionPlanCoordsData = await _dataService.getSessionPlanCoords(
  urlPath: sessionPlanUrl,
  forceRefresh: shouldForceRefresh, // Only refresh if area changed
);
```

**Expected Improvement**: 1-2 seconds saved for repeated date filter changes

---

### ✅ Solution 4: Skip Map Drilldown on Date-Only Changes (MEDIUM PRIORITY)
**File**: `lib/features/session_plan/presentation/screens/session_plan_screen.dart`

**Changes**:
1. Detect if only dates changed (compare previous vs current filter state)
2. Skip map drilldown if only dates changed
3. Only reload session plan data

**Implementation**:
```dart
// Check if only dates changed (in filter listener)
final onlyDatesChanged = 
    previous.selectedDivision == current.selectedDivision &&
    previous.selectedDistrict == current.selectedDistrict &&
    // ... check all area fields ...
    previous.selectedYear == current.selectedYear &&
    previous.selectedVaccine == current.selectedVaccine &&
    // Dates are different (check session plan state)
    (previous.startDate != current.startDate || 
     previous.endDate != current.endDate);

if (onlyDatesChanged) {
  // Only reload session plan data, skip map drilldown
  ref.read(sessionPlanControllerProvider.notifier).loadDataWithFilter();
  return;
}
```

**Expected Improvement**: 1-3 seconds saved by skipping unnecessary map operations

---

### ✅ Solution 5: Reduce Unnecessary Delays (LOW-MEDIUM PRIORITY)
**File**: 
- `lib/features/session_plan/presentation/widgets/session_plan_filter_dialog.dart`
- `lib/features/session_plan/presentation/screens/session_plan_screen.dart`

**Changes**:
1. Reduce delay in filter dialog from 200ms to 50ms (filter state updates faster)
2. Optimize upazilas wait logic - check more frequently initially
3. Add early exit conditions

**Implementation**:
```dart
// In filter dialog - reduce delay
await Future.delayed(const Duration(milliseconds: 50)); // Reduced from 200ms

// In upazilas wait - check more frequently initially
int retries = 0;
const maxRetries = 20; // Reduced from 30
const initialDelay = 50; // Start with 50ms
const maxDelay = 200; // Max 200ms

while (retries < maxRetries && mounted) {
  final delay = retries < 5 ? initialDelay : maxDelay; // Faster initial checks
  await Future.delayed(Duration(milliseconds: delay));
  // ... check logic ...
}
```

**Expected Improvement**: 200-1000ms saved per filter operation

---

### ✅ Solution 6: Optimize API Timeout for Session Plans (LOW PRIORITY)
**File**: `lib/features/session_plan/data/session_plan_repository.dart`

**Changes**:
1. Add specific timeout for session plan requests (15 seconds instead of 30)
2. Fail faster on slow networks

**Implementation**:
```dart
final response = await _client.get(
  urlPath,
  options: Options(
    receiveTimeout: const Duration(seconds: 15), // Reduced from 30
  ),
);
```

**Expected Improvement**: Faster failure detection on slow networks (doesn't improve success case)

---

## Implementation Priority

### Phase 1: Quick Wins (Implement First)
1. ✅ Solution 1: Skip GeoJSON reload when only dates change
2. ✅ Solution 2: Parallel loading of GeoJSON and session plan data
3. ✅ Solution 4: Skip map drilldown on date-only changes

**Expected Total Improvement**: 4-11 seconds saved per date filter change

### Phase 2: Additional Optimizations
4. ✅ Solution 3: Smart caching for session plan data
5. ✅ Solution 5: Reduce unnecessary delays

**Expected Additional Improvement**: 1-3 seconds saved

### Phase 3: Fine-tuning
6. ✅ Solution 6: Optimize API timeout

**Expected Additional Improvement**: Faster failure detection

---

## Testing Checklist

After implementing optimizations, verify:

- [ ] Date filtering works correctly (December 1-31, 2025)
- [ ] Area filtering still works correctly
- [ ] Combined area + date filtering works
- [ ] Map drilldown still works when area changes
- [ ] Map drilldown is skipped when only dates change
- [ ] GeoJSON is reused when area doesn't change
- [ ] Session plan count updates correctly
- [ ] No visual glitches or UI freezes
- [ ] Error handling still works (network errors, timeouts)
- [ ] Loading indicators show correctly

---

## Expected Performance Improvements

### Before Optimization:
- Date filter change: **8-15 seconds** (depending on network)

### After Phase 1 Optimizations:
- Date filter change: **3-6 seconds** (50-60% improvement)

### After All Optimizations:
- Date filter change: **2-4 seconds** (70-75% improvement)

---

## Notes

- All optimizations maintain existing functionality
- No breaking changes to API contracts
- Backward compatible with existing code
- Can be implemented incrementally
- Each solution can be tested independently
