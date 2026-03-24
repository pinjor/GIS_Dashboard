# Session Plan Filter Beyond District - Fix Documentation

## Problem Statement
Session Plan filtering works correctly up to the district level, but when users try to filter beyond district (Upazila, Union, Ward, Subblock), no EPI centers are displayed on the map.

## Root Cause Analysis

### Issue Identified
1. **Area Parameter Building Failure**: When filtering beyond district, the code tries to build concatenated paths like `district/upazila`, but if either UID is missing or null, the area parameter becomes `null` or `'undefined'`, causing the API to return 0 results.

2. **Missing Fallback Logic**: The code didn't have proper fallback strategies when UIDs couldn't be found, leading to `null` or `'undefined'` being passed to the API.

3. **URL Construction Issue**: The URL construction didn't handle empty area parameters correctly, potentially causing malformed API requests.

## Fixes Implemented

### Fix 1: Improved Area Parameter Building with Fallback Strategies
**File**: `lib/features/session_plan/presentation/controllers/session_plan_controller.dart`

**Changes**:
1. Added multiple fallback strategies when area UID cannot be built:
   - Strategy 1: Try map controller's `focalAreaUid`
   - Strategy 2: Use district UID as fallback if district is selected
   - Strategy 3: Use division UID as last resort if division is selected

2. Improved validation to never use `'undefined'` as area parameter:
   - If area UID is null/empty/undefined, use empty string instead
   - Empty string is handled properly in URL construction

**Code Location**: Lines ~193-250

### Fix 2: Enhanced Upazila Path Building with Fallbacks
**File**: `lib/features/session_plan/presentation/controllers/session_plan_controller.dart`

**Changes**:
1. Added validation to ensure UIDs are not just non-null, but also non-empty
2. Added fallback strategies:
   - If district UID is missing but upazila UID exists, use upazila UID only
   - If upazila UID is missing but district UID exists, use district UID only
   - Only return null if both UIDs are missing

3. Improved error logging to show available upazilas and their UIDs for debugging

**Code Location**: Lines ~730-750 (in `_buildAreaUidForSessionPlan` method)

### Fix 3: Improved URL Construction
**File**: `lib/features/session_plan/presentation/controllers/session_plan_controller.dart`

**Changes**:
1. Only include area parameter in URL if it's not empty
2. Properly handle query parameter construction when area parameter is empty
3. Ensure date parameters are always included correctly

**Code Location**: Lines ~233-260

## Testing Checklist

After implementing the fixes, verify:

- [ ] District-level filtering still works correctly
- [ ] Upazila-level filtering now shows EPI centers
- [ ] Union-level filtering shows EPI centers
- [ ] Ward-level filtering shows EPI centers
- [ ] Subblock-level filtering shows EPI centers (if applicable)
- [ ] Error messages are clear when area data is missing
- [ ] Fallback strategies work when UIDs are partially available
- [ ] API calls are made with correct area parameter format
- [ ] Session count displays correctly in filter dialog
- [ ] Markers display on map for all filter levels

## Expected Behavior After Fix

### Before Fix:
- District filter: ✅ Works (shows EPI centers)
- Upazila filter: ❌ No EPI centers displayed
- Union filter: ❌ No EPI centers displayed
- Ward filter: ❌ No EPI centers displayed

### After Fix:
- District filter: ✅ Works (shows EPI centers)
- Upazila filter: ✅ Works (shows EPI centers)
- Union filter: ✅ Works (shows EPI centers)
- Ward filter: ✅ Works (shows EPI centers)

## API Parameter Format

The session plan API expects:
- **District level**: Single UID (e.g., `qctlb4zamgb`)
- **Upazila level**: Concatenated path (e.g., `qctlb4zamgb/wfn5xpxfi4k`)
- **Union level**: Concatenated path (e.g., `qctlb4zamgb/wfn5xpxfi4k/union_uid`)
- **Ward level**: Concatenated path (e.g., `qctlb4zamgb/wfn5xpxfi4k/union_uid/ward_uid`)

All UIDs in concatenated paths must be lowercase.

## Debugging Tips

If the issue persists after the fix:

1. **Check Logs**: Look for these log messages:
   - `Session Plan: 🔍🔍🔍 Building area UID for session plan API`
   - `Session Plan: ✅✅✅ Area UID is valid: <uid>`
   - `Session Plan: ❌❌❌ CRITICAL ERROR - area UID is null or undefined!`

2. **Verify UIDs**: Check if UIDs are being retrieved correctly:
   - `Session Plan: Upazilas list: <list of upazilas with UIDs>`
   - `Session Plan: Districts list: <list of districts with UIDs>`

3. **Check API URL**: Verify the full API URL being called:
   - `Session Plan: 🔍🔍🔍 FULL API URL: <url>`

4. **Verify API Response**: Check if API returns data:
   - `Session Plan Repository: ✅✅✅ session_count field found: <count>`
   - `Session Plan Repository: features count: <count>`

## Related Issues

This fix addresses the same root cause as:
- `SESSION_PLAN_UPazILLA_FIX_PLAN.md` - Upazila filter not showing markers
- The issue where filtering beyond district returns 0 results

## Notes

- The fix maintains backward compatibility with district-level filtering
- Fallback strategies ensure the app doesn't crash even if UIDs are missing
- Empty area parameter is handled gracefully (API may return country-level data)
- All concatenated paths use lowercase UIDs as required by the API

---

**Fix Date**: January 2025  
**Status**: Implemented  
**Priority**: High
