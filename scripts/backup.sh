#!/bin/bash

###############################################################################
# GIS Dashboard Backup Script
# 
# This script creates backups of important project files including
# configuration, source code, and documentation.
#
# Usage:
#   ./scripts/backup.sh
#
# The backup will be created in the ./backups/ directory with a timestamp.
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
BACKUP_DIR="$PROJECT_ROOT/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="gis_dashboard_backup_$TIMESTAMP"

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
echo -e "${GREEN}║     GIS Dashboard Backup Script                            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
log_info "Creating backup: $BACKUP_NAME"

# Change to project root
cd "$PROJECT_ROOT"

# Create backup directory
mkdir -p "$BACKUP_DIR/$BACKUP_NAME"

# Backup important files
log_info "Backing up configuration files..."
if [ -f ".env" ]; then
    cp .env "$BACKUP_DIR/$BACKUP_NAME/" && log_success "Backed up .env"
else
    log_warning "No .env file found (this is normal if not configured)"
fi

if [ -f "pubspec.yaml" ]; then
    cp pubspec.yaml "$BACKUP_DIR/$BACKUP_NAME/" && log_success "Backed up pubspec.yaml"
fi

if [ -f "pubspec.lock" ]; then
    cp pubspec.lock "$BACKUP_DIR/$BACKUP_NAME/" && log_success "Backed up pubspec.lock"
fi

log_info "Backing up source code..."
if [ -d "lib" ]; then
    cp -r lib "$BACKUP_DIR/$BACKUP_NAME/" && log_success "Backed up lib directory"
else
    log_warning "No lib directory found"
fi

log_info "Backing up documentation..."
if [ -d "docs" ]; then
    cp -r docs "$BACKUP_DIR/$BACKUP_NAME/" && log_success "Backed up docs directory"
else
    log_warning "No docs directory found"
fi

if [ -f "README.md" ]; then
    cp README.md "$BACKUP_DIR/$BACKUP_NAME/" && log_success "Backed up README.md"
fi

# Backup scripts
log_info "Backing up scripts..."
if [ -d "scripts" ]; then
    cp -r scripts "$BACKUP_DIR/$BACKUP_NAME/" && log_success "Backed up scripts directory"
fi

# Backup Docker configuration
log_info "Backing up Docker configuration..."
if [ -d "docker" ]; then
    cp -r docker "$BACKUP_DIR/$BACKUP_NAME/" && log_success "Backed up docker directory"
fi

# Create archive
log_info "Creating archive..."
cd "$BACKUP_DIR"
if tar -czf "${BACKUP_NAME}.tar.gz" "$BACKUP_NAME" 2>/dev/null; then
    log_success "Archive created successfully"
    rm -rf "$BACKUP_NAME"
    
    # Get file size
    FILE_SIZE=$(du -h "${BACKUP_NAME}.tar.gz" | cut -f1)
    
    echo ""
    log_success "╔════════════════════════════════════════════════════════════╗"
    log_success "║     Backup completed successfully!                       ║"
    log_success "╚════════════════════════════════════════════════════════════╝"
    echo ""
    log_info "Backup location: $BACKUP_DIR/${BACKUP_NAME}.tar.gz"
    log_info "Backup size: $FILE_SIZE"
    echo ""
else
    log_error "Failed to create archive"
    exit 1
fi
