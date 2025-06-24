#!/bin/bash

# Build script for creating all Xenofetch packages
set -e

# Get latest version from git tags or default
get_version() {
    if git describe --tags --exact-match HEAD 2>/dev/null; then
        git describe --tags --exact-match HEAD | sed 's/^v//'
    elif git rev-parse --verify HEAD >/dev/null 2>&1; then
        echo "dev-$(git rev-parse --short HEAD)"
    else
        echo "1.0.0"
    fi
}

VERSION=$(get_version)
PROJECT_NAME="xenofetch"
REPO_OWNER="cptcr"
BUILD_DIR="build"
DIST_DIR="dist"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
    exit 1
}

warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Clean and create directories
cleanup() {
    log "Cleaning build directories..."
    rm -rf "$BUILD_DIR" "$DIST_DIR"
    mkdir -p "$BUILD_DIR" "$DIST_DIR"
}

# Build Debian package
build_deb() {
    log "Building Debian package..."
    
    local deb_dir="$BUILD_DIR/debian"
    mkdir -p "$deb_dir/DEBIAN"
    mkdir -p "$deb_dir/usr/bin"
    mkdir -p "$deb_dir/usr/share/doc/$PROJECT_NAME"
    mkdir -p "$deb_dir/usr/share/man/man1"
    mkdir -p "$deb_dir/usr/share/$PROJECT_NAME"
    
    # Copy files
    cp DEBIAN/control "$deb_dir/DEBIAN/"
    cp DEBIAN/postinst "$deb_dir/DEBIAN/"
    cp xenofetch.sh "$deb_dir/usr/bin/xenofetch"
    cp main.sh "$deb_dir/usr/share/$PROJECT_NAME/"
    cp README.md "$deb_dir/usr/share/doc/$PROJECT_NAME/"
    cp LICENSE "$deb_dir/usr/share/doc/$PROJECT_NAME/"
    
    # Copy man page if it exists
    if [ -f xenofetch.1 ]; then
        cp xenofetch.1 "$deb_dir/usr/share/man/man1/"
    fi
    
    # Update version in control file
    sed -i "s/Version: .*/Version: $VERSION/" "$deb_dir/DEBIAN/control"
    
    # Set permissions
    chmod 755 "$deb_dir/DEBIAN/postinst"
    chmod 755 "$deb_dir/usr/bin/xenofetch"
    chmod 644 "$deb_dir/usr/share/$PROJECT_NAME/main.sh"
    
    # Build package
    dpkg-deb --build "$deb_dir" "$DIST_DIR/${PROJECT_NAME}_${VERSION}_all.deb"
    success "Debian package created: ${PROJECT_NAME}_${VERSION}_all.deb"
}

# Build tarball for Arch Linux
build_arch() {
    log "Building Arch Linux source tarball..."
    
    local arch_dir="$BUILD_DIR/arch"
    mkdir -p "$arch_dir"
    
    # Create source tarball
    tar -czf "$DIST_DIR/${PROJECT_NAME}-${VERSION}.tar.gz" \
        --exclude="$BUILD_DIR" \
        --exclude="$DIST_DIR" \
        --exclude=".git" \
        --transform "s,^,${PROJECT_NAME}-${VERSION}/," \
        .
    
    # Copy PKGBUILD with updated version
    cp PKGBUILD "$DIST_DIR/"
    sed -i "s/pkgver=.*/pkgver=$VERSION/" "$DIST_DIR/PKGBUILD"
    
    success "Arch Linux tarball created: ${PROJECT_NAME}-${VERSION}.tar.gz"
}

# Build Snap package
build_snap() {
    log "Building Snap package..."
    
    if ! command -v snapcraft >/dev/null 2>&1; then
        warn "snapcraft not found, skipping Snap package"
        return
    fi
    
    # Update version in snapcraft.yaml
    sed -i "s/version: .*/version: '$VERSION'/" snap/snapcraft.yaml
    
    snapcraft clean
    snapcraft
    
    if [ -f "${PROJECT_NAME}_${VERSION}_amd64.snap" ]; then
        mv "${PROJECT_NAME}_${VERSION}_amd64.snap" "$DIST_DIR/"
        success "Snap package created: ${PROJECT_NAME}_${VERSION}_amd64.snap"
    fi
}

# Build Chocolatey package
build_chocolatey() {
    log "Building Chocolatey package..."
    
    local choco_dir="$BUILD_DIR/chocolatey"
    mkdir -p "$choco_dir/tools"
    
    # Copy files
    cp xenofetch.nuspec "$choco_dir/"
    cp chocolateyinstall.ps1 "$choco_dir/tools/"
    
    # Update version in nuspec
    sed -i "s/<version>.*<\/version>/<version>$VERSION<\/version>/" "$choco_dir/xenofetch.nuspec"
    
    # Update URLs in nuspec
    sed -i "s/yourusername/$REPO_OWNER/g" "$choco_dir/xenofetch.nuspec"
    
    # Build if choco is available
    if command -v choco >/dev/null 2>&1; then
        cd "$choco_dir"
        choco pack
        mv "xenofetch.${VERSION}.nupkg" "../../$DIST_DIR/"
        cd - >/dev/null
        success "Chocolatey package created: xenofetch.${VERSION}.nupkg"
    else
        warn "choco command not found, created package files only"
        cp -r "$choco_dir" "$DIST_DIR/chocolatey-source"
    fi
}

# Generate checksums
generate_checksums() {
    log "Generating checksums..."
    
    cd "$DIST_DIR"
    for file in *; do
        if [ -f "$file" ]; then
            sha256sum "$file" >> checksums.txt
        fi
    done
    cd - >/dev/null
    
    success "Checksums generated: checksums.txt"
}

# Create release notes
create_release_notes() {
    log "Creating release notes..."
    
    cat > "$DIST_DIR/RELEASE_NOTES.md" << EOF
# Xenofetch v${VERSION} Release

## Installation Instructions

### Homebrew (macOS/Linux)
\`\`\`bash
brew tap cptcr/xenofetch
brew install xenofetch
\`\`\`

### Chocolatey (Windows)
\`\`\`powershell
choco install xenofetch
\`\`\`

### APT (Debian/Ubuntu)
\`\`\`bash
wget https://github.com/cptcr/xenofetch/releases/download/v${VERSION}/xenofetch_${VERSION}_all.deb
sudo dpkg -i xenofetch_${VERSION}_all.deb
\`\`\`

### Snap (Universal Linux)
\`\`\`bash
sudo snap install xenofetch
\`\`\`

### Pacman (Arch Linux)
\`\`\`bash
# Using AUR helper (yay, paru, etc.)
yay -S xenofetch

# Or manual installation
wget https://github.com/cptcr/xenofetch/releases/download/v${VERSION}/PKGBUILD
makepkg -si
\`\`\`

### Manual Installation
\`\`\`bash
curl -fsSL https://raw.githubusercontent.com/cptcr/xenofetch/main/install.sh | bash
\`\`\`

## What's New in v${VERSION}
- Enhanced system information display
- Beautiful styled tables with gradient effects
- Cross-platform compatibility
- Comprehensive hardware and software detection
- Network and process information
- Temperature monitoring support

## Files in this Release
EOF

    cd "$DIST_DIR"
    for file in *; do
        if [ -f "$file" ] && [ "$file" != "RELEASE_NOTES.md" ]; then
            echo "- \`$file\`" >> RELEASE_NOTES.md
        fi
    done
    cd - >/dev/null
    
    success "Release notes created: RELEASE_NOTES.md"
}

# Main build process
main() {
    log "Starting Xenofetch v${VERSION} package build..."
    
    cleanup
    build_deb
    build_arch
    build_snap
    build_chocolatey
    generate_checksums
    create_release_notes
    
    log "Build complete! Check the $DIST_DIR directory for packages."
    success "All packages built successfully!"
}

# Check for required tools
check_dependencies() {
    local missing=()
    
    command -v dpkg-deb >/dev/null 2>&1 || missing+=("dpkg-deb")
    command -v tar >/dev/null 2>&1 || missing+=("tar")
    command -v sha256sum >/dev/null 2>&1 || missing+=("sha256sum")
    
    if [ ${#missing[@]} -ne 0 ]; then
        error "Missing required tools: ${missing[*]}"
    fi
}

# Run the build
if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
    echo "Xenofetch Package Builder"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "This script builds packages for multiple package managers:"
    echo "  - Debian (.deb) for APT"
    echo "  - Source tarball for Arch Linux (Pacman)"
    echo "  - Snap package"
    echo "  - Chocolatey package"
    echo ""
    echo "Requirements:"
    echo "  - dpkg-deb (for .deb packages)"
    echo "  - tar, sha256sum (standard tools)"
    echo "  - snapcraft (optional, for Snap packages)"
    echo "  - choco (optional, for Chocolatey packages)"
    exit 0
fi

check_dependencies
main