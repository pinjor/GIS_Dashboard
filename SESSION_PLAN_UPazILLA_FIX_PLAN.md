# Session Plan Upazilla Filter Fix Plan

## Problem Statement
When filtering by upazilla, the session plan markers (EPI centers) are not showing on the map, even though:
- The map boundaries display correctly
- The area is correctly identified
- The API is being called

**Expected**: Purple markers with leaf icons scattered across the upazilla (like first image)
**Actual**: No markers displayed, only boundaries and labels (like second image)

## Root Cause Analysis

Based on code review and logs, the likely root causes are:

### 1. **API Returning 0 Sessions** (PRIMARY ISSUE)
   - The API is returning `session_count: 0` and empty `features` array
   - This means either:
     - Area parameter format is incorrect
     - Date range has no sessions
     - API endpoint expects different format for upazilla level

### 2. **Area Parameter Format Issue**
   - Current format: `area=district_uid/upazilla_uid` (lowercase, e.g., `qctlb4zamgb/wfn5xpxfi4k`)
   - Possible issues:
     - API might expect uppercase UIDs
     - API might expect different separator
     - API might need URL encoding
     - API might expect slug format instead of UID

### 3. **Date Range Issue**
   - Dates might be defaulting to today when user expects a range
   - If today has no sessions, API returns 0 results
   - Need to verify date format and range

### 4. **Timing Issue** (PARTIALLY FIXED)
   - Upazilas list might be empty when building area UID
   - **Status**: Fixed in previous update with retry logic

## Diagnostic Steps

### Step 1: Add Comprehensive Logging
Add detailed logging to track:
- Exact API URL being called
- Area parameter value and format
- Date parameters
- Raw API response
- Parsed response data

### Step 2: Verify Area Parameter Format
Test different formats:
- `district_uid/upazilla_uid` (current - lowercase)
- `DISTRICT_UID/upazilla_uid` (mixed case)
- `district_uid-upazilla_uid` (hyphen separator)
- URL encoded version

### Step 3: Verify Date Range
- Check if dates are being set correctly
- Verify date format (YYYY-MM-DD)
- Test with different date ranges
- Check if defaulting to today is causing issues

### Step 4: Test API Directly
- Use a tool like Postman/curl to test the API directly
- Compare working requests (division/district) vs non-working (upazilla)
- Identify the exact format that works

## Fix Strategy

### Fix 1: Improve Area Parameter Building
- Ensure UIDs are correctly retrieved (already fixed with retry logic)
- Verify lowercase conversion is correct
- Add URL encoding if needed
- Test with different separator formats

### Fix 2: Fix Date Range Handling
- Ensure dates are preserved from user selection
- Don't default to today if user selected a range
- Add validation for date ranges

### Fix 3: Add Fallback Logic
- If API returns 0 sessions, try alternative area parameter formats
- Log all attempts for debugging
- Show user-friendly error message

### Fix 4: Improve Error Handling
- Show clear error messages when no sessions found
- Suggest checking date range
- Provide debugging information in logs

## Implementation Plan

### Phase 1: Enhanced Logging (IMMEDIATE)
1. Add detailed logging in `session_plan_controller.dart`:
   - Log exact API URL before calling
   - Log area parameter format
   - Log date parameters
   - Log raw response
   - Log parsed response

2. Add logging in `session_plan_repository.dart`:
   - Log request URL
   - Log response status
   - Log response body size
   - Log session_count and features count

### Phase 2: Area Parameter Verification (HIGH PRIORITY)
1. Verify UID format:
   - Check if UIDs need to be uppercase
   - Check if separator needs to be different
   - Check if URL encoding is needed

2. Add format validation:
   - Validate area parameter before API call
   - Log warnings if format looks incorrect
   - Try alternative formats if first attempt fails

### Phase 3: Date Range Fix (HIGH PRIORITY)
1. Ensure dates are preserved:
   - Store dates in state immediately
   - Use dates from state when filter changes
   - Don't default to today if user selected range

2. Add date validation:
   - Validate date range is reasonable
   - Warn if date range is too narrow
   - Suggest expanding range if no results

### Phase 4: Testing & Validation
1. Test with different upazillas
2. Test with different date ranges
3. Compare with working division/district filters
4. Verify markers display correctly

## Expected Outcomes

After fixes:
1. ✅ API returns correct session_count and features for upazilla filter
2. ✅ Markers display on map when filtering by upazilla
3. ✅ Session count shows correctly in filter dialog
4. ✅ User can see EPI centers (purple markers) on map

## Next Steps

1. **Immediate**: Add comprehensive logging to identify exact issue
2. **Short-term**: Fix area parameter format based on logs
3. **Short-term**: Fix date range handling
4. **Long-term**: Add better error handling and user feedback
