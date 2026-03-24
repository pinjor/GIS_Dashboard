# Troubleshooting Guide

## Common Issues and Solutions

### Build Issues

#### Issue: Build Runner Fails

**Symptoms**:
- Error: "Conflicting outputs were detected"
- Generated files are out of sync

**Solution**:
```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

#### Issue: Missing Generated Files

**Symptoms**:
- Compilation errors for `.freezed.dart` or `.g.dart` files
- "File not found" errors

**Solution**:
1. Run build_runner:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
2. If issue persists, clean and rebuild:
   ```bash
   flutter clean
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```

#### Issue: Dependency Conflicts

**Symptoms**:
- `pub get` fails with version conflicts
- Package resolution errors

**Solution**:
1. Update dependencies:
   ```bash
   flutter pub upgrade
   ```
2. Check `pubspec.lock` for conflicts
3. Manually resolve version conflicts in `pubspec.yaml`

### Runtime Issues

#### Issue: Map Not Loading

**Symptoms**:
- Blank map screen
- No polygons displayed
- Loading indicator never stops

**Solutions**:
1. **Check Internet Connection**:
   - Verify device has internet access
   - Check API server is accessible

2. **Check API Response**:
   - Verify API endpoints are correct
   - Check `.env` file configuration
   - Test API endpoints manually

3. **Check Logs**:
   - Look for network errors in console
   - Check for SSL certificate issues
   - Verify GeoJSON decompression

4. **Clear Cache**:
   ```bash
   flutter clean
   flutter pub get
   ```

#### Issue: Location Permission Denied

**Symptoms**:
- EPI Center Finder can't get location
- Permission error messages

**Solutions**:
1. **Android**:
   - Check `AndroidManifest.xml` has location permissions
   - Grant permission in device settings
   - Test on physical device (not emulator)

2. **iOS**:
   - Check `Info.plist` has location usage descriptions
   - Grant permission in device settings
   - Test on physical device

3. **Debug**:
   - Check permission status in logs
   - Verify permission_handler package is working
   - Test with location services enabled

#### Issue: EPI Centers Not Showing

**Symptoms**:
- No markers on map
- Empty results in table
- "No EPI centers found" message

**Solutions**:
1. **Check Date Range**:
   - Verify date range is valid
   - Check if sessions exist for selected dates
   - Try different date range

2. **Check Location**:
   - Verify GPS is enabled
   - Check location accuracy
   - Ensure within 5km radius

3. **Check API Response**:
   - Verify API returns data for date range
   - Check `session_count` in response
   - Verify features array is not empty

4. **Check Filters**:
   - Clear all filters
   - Reset to country view
   - Try different area selections

#### Issue: Slow Performance

**Symptoms**:
- App freezes during loading
- Slow map rendering
- Delayed UI updates

**Solutions**:
1. **Reduce Marker Count**:
   - Check marker limits in code
   - Filter data before rendering
   - Use marker clustering (future enhancement)

2. **Optimize Data Loading**:
   - Implement caching
   - Load data in background
   - Use pagination for large datasets

3. **Check Device**:
   - Test on higher-end device
   - Close other apps
   - Check available memory

### Network Issues

#### Issue: SSL Certificate Errors

**Symptoms**:
- "Certificate verification failed" errors
- Connection refused errors

**Solutions**:
1. **Staging Environment**:
   - SSL bypass is configured for staging (debug only)
   - Verify `StagingSslAdapter` is working

2. **Production**:
   - Ensure valid SSL certificate
   - Check certificate expiration
   - Verify certificate chain

#### Issue: API Timeout

**Symptoms**:
- Requests timeout after 30 seconds
- "Connection timeout" errors

**Solutions**:
1. **Check Network**:
   - Verify internet connection
   - Test API server response time
   - Check for network congestion

2. **Adjust Timeouts**:
   - Increase timeout in `dio_client_provider.dart`
   - Implement retry logic
   - Add timeout handling

3. **Optimize Requests**:
   - Reduce data size
   - Use compression
   - Implement request batching

### State Management Issues

#### Issue: State Not Updating

**Symptoms**:
- UI doesn't reflect state changes
- Filters not applying
- Map not updating

**Solutions**:
1. **Check Provider Scope**:
   - Verify `ProviderScope` wraps app
   - Check provider initialization
   - Verify provider dependencies

2. **Check State Listeners**:
   - Verify `ref.watch()` is used correctly
   - Check `ref.listen()` callbacks
   - Ensure state mutations trigger rebuilds

3. **Debug State**:
   - Add logging to state changes
   - Check state values in debugger
   - Verify state immutability

### Platform-Specific Issues

#### Android

**Issue: Build Fails**
- Check Android SDK version
- Verify Gradle version compatibility
- Check `local.properties` configuration

**Issue: App Crashes on Launch**
- Check logcat for errors
- Verify permissions in manifest
- Check for missing dependencies

#### iOS

**Issue: Build Fails**
- Check Xcode version
- Verify CocoaPods installation
- Run `pod install` in `ios/` directory

**Issue: App Crashes on Launch**
- Check device logs
- Verify Info.plist configuration
- Check for missing entitlements

## Debugging Tips

### Enable Debug Logging

The application uses the `logger` package. Enable verbose logging:

```dart
// In utils.dart or main.dart
Logger.level = Level.ALL;
```

### Check Network Requests

1. Enable Dio logging interceptor
2. Check request/response in console
3. Verify API endpoints and parameters

### Inspect State

1. Use Flutter DevTools
2. Add breakpoints in controllers
3. Check Riverpod state in debugger

### Test API Endpoints

Use tools like Postman or cURL to test API endpoints directly:

```bash
curl "https://staging.gisdashboard.online/api/v1/session-plans?start_date=2025-12-01&end_date=2025-12-31"
```

## Getting Help

1. **Check Logs**: Review application logs for error messages
2. **Check Documentation**: Review `docs/` folder
3. **Check Issues**: Search GitHub issues for similar problems
4. **Create Issue**: Create detailed issue with:
   - Error messages
   - Steps to reproduce
   - Device/platform information
   - Logs and screenshots

## Prevention

1. **Regular Updates**: Keep dependencies updated
2. **Testing**: Test on multiple devices/platforms
3. **Code Review**: Review code before merging
4. **Documentation**: Keep documentation updated
5. **Monitoring**: Monitor app performance and errors
