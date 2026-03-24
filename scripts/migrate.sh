#!/bin/bash

###############################################################################
# GIS Dashboard Migration Script
# 
# This script helps migrate the project after dependency updates or major
# changes. It performs a complete cleanup, dependency update, code generation,
# and validation.
#
# Usage:
#   ./scripts/migrate.sh
#
# This script will:
#   1. Clean previous builds
#   2. Update dependencies
#   3. Regenerate code
#   4. Analyze code
#   5. Run tests
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
echo -e "${GREEN}║     GIS Dashboard Migration Script                         ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Change to project root
cd "$PROJECT_ROOT"

# Check Flutter installation
if ! command -v flutter &> /dev/null; then
    log_error "Flutter is not installed or not in PATH"
    log_info "Please install Flutter from https://flutter.dev/docs/get-started/install"
    exit 1
fi

log_info "Starting migration process..."

# Clean previous builds
log_info "Cleaning previous builds..."
if flutter clean; then
    log_success "Clean completed"
else
    log_warning "Clean had issues, continuing..."
fi

# Get latest dependencies
log_info "Getting dependencies..."
if flutter pub get; then
    log_success "Dependencies retrieved"
else
    log_error "Failed to get dependencies"
    exit 1
fi

# Upgrade dependencies
log_info "Upgrading dependencies..."
if flutter pub upgrade; then
    log_success "Dependencies upgraded"
else
    log_warning "Some dependencies may not have upgraded"
fi

# Generate code
log_info "Regenerating code..."
log_info "Cleaning build_runner cache..."
dart run build_runner clean || log_warning "Build runner clean had issues"

log_info "Building generated code..."
if dart run build_runner build --delete-conflicting-outputs; then
    log_success "Code generation completed"
else
    log_error "Code generation failed"
    exit 1
fi

# Analyze code
log_info "Analyzing code..."
if flutter analyze; then
    log_success "Code analysis passed"
else
    log_warning "Code analysis found issues - please review"
fi

# Run tests
log_info "Running tests..."
if flutter test; then
    log_success "All tests passed"
else
    log_error "Tests failed"
    exit 1
fi

# Print summary
echo ""
log_success "╔════════════════════════════════════════════════════════════╗"
log_success "║     Migration completed successfully!                   ║"
log_success "╚════════════════════════════════════════════════════════════╝"
echo ""
log_info "Next steps:"
echo "  1. Review any warnings or errors above"
echo "  2. Test the application: flutter run"
echo "  3. Commit changes if everything looks good"
echo ""
