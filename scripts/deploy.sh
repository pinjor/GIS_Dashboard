#!/bin/bash

###############################################################################
# GIS Dashboard Deployment Script
# 
# This script automates the deployment process for the Flutter application.
# It handles dependency installation, code generation, testing, and building
# for multiple platforms.
#
# Usage:
#   ./scripts/deploy.sh [platform] [build_type]
#
# Arguments:
#   platform    - Target platform: android, ios, web, windows, linux, macos
#                 (default: android)
#   build_type  - Build type: debug, release, profile
#                 (default: release)
#
# Examples:
#   ./scripts/deploy.sh android release
#   ./scripts/deploy.sh ios debug
#   ./scripts/deploy.sh web release
#
###############################################################################

set -e  # Exit on error
set -u  # Exit on undefined variable

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PLATFORM="${1:-android}"  # android, ios, web, windows, linux, macos
BUILD_TYPE="${2:-release}"  # debug, release, profile

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Print header
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     GIS Dashboard Deployment Script                       ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
log_info "Starting deployment for $PLATFORM ($BUILD_TYPE)..."

# Change to project root
cd "$PROJECT_ROOT"

# Check Flutter installation
if ! command -v flutter &> /dev/null; then
    log_error "Flutter is not installed or not in PATH"
    log_info "Please install Flutter from https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Get Flutter version
FLUTTER_VERSION=$(flutter --version | head -n 1)
log_info "Using $FLUTTER_VERSION"

# Validate platform
VALID_PLATFORMS=("android" "ios" "web" "windows" "linux" "macos")
if [[ ! " ${VALID_PLATFORMS[@]} " =~ " ${PLATFORM} " ]]; then
    log_error "Invalid platform: $PLATFORM"
    log_info "Valid platforms: ${VALID_PLATFORMS[*]}"
    exit 1
fi

# Validate build type
VALID_BUILD_TYPES=("debug" "release" "profile")
if [[ ! " ${VALID_BUILD_TYPES[@]} " =~ " ${BUILD_TYPE} " ]]; then
    log_error "Invalid build type: $BUILD_TYPE"
    log_info "Valid build types: ${VALID_BUILD_TYPES[*]}"
    exit 1
fi

# Clean previous builds
log_info "Cleaning previous builds..."
flutter clean || {
    log_warning "Clean command had issues, continuing..."
}

# Get dependencies
log_info "Getting dependencies..."
flutter pub get || {
    log_error "Failed to get dependencies"
    exit 1
}

# Generate code
log_info "Generating code with build_runner..."
dart run build_runner build --delete-conflicting-outputs || {
    log_error "Code generation failed"
    exit 1
}

# Run tests
log_info "Running tests..."
if flutter test; then
    log_success "All tests passed"
else
    log_error "Tests failed. Aborting deployment."
    exit 1
fi

# Analyze code
log_info "Analyzing code..."
if flutter analyze; then
    log_success "Code analysis passed"
else
    log_warning "Analysis found issues. Continuing anyway..."
fi

# Build based on platform
log_info "Building for $PLATFORM ($BUILD_TYPE)..."
case $PLATFORM in
    android)
        log_info "Building Android APK..."
        if flutter build apk --$BUILD_TYPE; then
            log_success "Android APK built successfully"
        else
            log_error "Failed to build Android APK"
            exit 1
        fi
        
        if [ "$BUILD_TYPE" = "release" ]; then
            log_info "Building Android App Bundle..."
            if flutter build appbundle --release; then
                log_success "Android App Bundle built successfully"
            else
                log_warning "Failed to build App Bundle, but APK is available"
            fi
        fi
        ;;
    ios)
        log_info "Building iOS..."
        if flutter build ios --$BUILD_TYPE --no-codesign; then
            log_success "iOS build completed successfully"
        else
            log_error "Failed to build iOS"
            exit 1
        fi
        ;;
    web)
        log_info "Building Web..."
        if flutter build web --$BUILD_TYPE; then
            log_success "Web build completed successfully"
        else
            log_error "Failed to build Web"
            exit 1
        fi
        ;;
    windows)
        log_info "Building Windows..."
        if flutter build windows --$BUILD_TYPE; then
            log_success "Windows build completed successfully"
        else
            log_error "Failed to build Windows"
            exit 1
        fi
        ;;
    linux)
        log_info "Building Linux..."
        if flutter build linux --$BUILD_TYPE; then
            log_success "Linux build completed successfully"
        else
            log_error "Failed to build Linux"
            exit 1
        fi
        ;;
    macos)
        log_info "Building macOS..."
        if flutter build macos --$BUILD_TYPE; then
            log_success "macOS build completed successfully"
        else
            log_error "Failed to build macOS"
            exit 1
        fi
        ;;
esac

# Print summary
echo ""
log_success "╔════════════════════════════════════════════════════════════╗"
log_success "║     Deployment completed successfully!                    ║"
log_success "╚════════════════════════════════════════════════════════════╝"
echo ""
log_info "Build artifacts location:"
case $PLATFORM in
    android)
        if [ "$BUILD_TYPE" = "release" ]; then
            echo "  - APK: build/app/outputs/flutter-apk/app-release.apk"
            echo "  - App Bundle: build/app/outputs/bundle/release/app-release.aab"
        else
            echo "  - APK: build/app/outputs/flutter-apk/app-$BUILD_TYPE.apk"
        fi
        ;;
    ios)
        echo "  - iOS: build/ios/iphoneos/Runner.app"
        ;;
    web)
        echo "  - Web: build/web/"
        ;;
    windows)
        echo "  - Windows: build/windows/$BUILD_TYPE/runner/"
        ;;
    linux)
        echo "  - Linux: build/linux/$BUILD_TYPE/bundle/"
        ;;
    macos)
        echo "  - macOS: build/macos/Build/Products/$BUILD_TYPE/"
        ;;
esac
echo ""
