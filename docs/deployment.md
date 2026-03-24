# Deployment Documentation

## Prerequisites

- Flutter SDK 3.8.1 or higher
- Dart SDK
- Android SDK (for Android builds)
- Xcode (for iOS builds, macOS only)
- Code signing certificates (for production builds)

## Environment Setup

### 1. Create Environment File

Copy `.env.example` to `.env` and configure:

```env
URL_SCHEME=https
STAGING_SERVER_HOST=staging.gisdashboard.online
STAGING_SERVER_FULL_URL=https://staging.gisdashboard.online
URL_COMMON_PATH=/api/v1
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Code

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Build Configurations

### Android

#### Debug Build

```bash
flutter build apk --debug
```

#### Release Build

```bash
flutter build apk --release
```

#### App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

**Requirements**:
- Signing key configured in `android/app/build.gradle.kts`
- `key.properties` file with keystore information

### iOS

#### Debug Build

```bash
flutter build ios --debug
```

#### Release Build

```bash
flutter build ios --release
```

**Requirements**:
- Valid Apple Developer account
- Provisioning profiles configured
- Signing certificates installed

### Web

```bash
flutter build web --release
```

**Deployment**:
- Deploy `build/web/` directory to web server
- Configure server for SPA routing

### Windows

```bash
flutter build windows --release
```

### Linux

```bash
flutter build linux --release
```

### macOS

```bash
flutter build macos --release
```

## Platform-Specific Configuration

### Android

#### Permissions

Location permissions are configured in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

#### Signing

1. Generate keystore:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Create `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path-to-keystore>
```

3. Configure `android/app/build.gradle.kts` to use signing config

### iOS

#### Permissions

Location permissions are configured in `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to find nearby EPI centers.</string>
```

#### Code Signing

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select target → Signing & Capabilities
3. Configure Team and Provisioning Profile

## Continuous Integration/Deployment

### GitHub Actions

See `.github/workflows/` for CI/CD workflows.

**Workflows**:
- `ci.yml`: Run tests and linting
- `build.yml`: Build artifacts for all platforms

### Manual Deployment

1. **Build artifacts**:
   ```bash
   flutter build apk --release
   flutter build appbundle --release
   flutter build ios --release
   ```

2. **Upload to stores**:
   - Android: Upload `.aab` to Google Play Console
   - iOS: Upload via Xcode or Transporter

## Version Management

### Version Numbering

Format: `major.minor.patch+build`

- **Major**: Breaking changes
- **Minor**: New features (backward compatible)
- **Patch**: Bug fixes
- **Build**: Build number

Update in `pubspec.yaml`:
```yaml
version: 1.0.0+1
```

## Environment Variables

### Development

Use `.env` file (gitignored) for local development.

### Production

Set environment variables in:
- CI/CD pipeline
- App configuration
- Build scripts

## Troubleshooting

### Common Issues

1. **Build Failures**:
   - Check Flutter/Dart SDK versions
   - Run `flutter clean` and rebuild
   - Verify dependencies: `flutter pub get`

2. **Code Generation Errors**:
   - Run `dart run build_runner clean`
   - Run `dart run build_runner build --delete-conflicting-outputs`

3. **Signing Errors** (Android/iOS):
   - Verify certificates are valid
   - Check keystore passwords
   - Ensure provisioning profiles are installed

4. **Location Permission Issues**:
   - Verify permissions in manifests
   - Test on physical device (not emulator)
   - Check location services are enabled

## Post-Deployment

1. **Monitor**:
   - Error tracking (if implemented)
   - User feedback
   - Performance metrics

2. **Update Documentation**:
   - Update CHANGELOG.md
   - Update version numbers
   - Update deployment notes

3. **Rollback Plan**:
   - Keep previous version artifacts
   - Document rollback procedure
   - Test rollback process
