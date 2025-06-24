#!/bin/bash

# Update version script for Xenofetch
# Author: Anton Schmidt (cptcr)
# Usage: ./update-version.sh [new_version]

set -e

NEW_VERSION="$1"

if [[ -z "$NEW_VERSION" ]]; then
    echo "Usage: $0 <new_version>"
    echo "Example: $0 1.0.1"
    exit 1
fi

# Validate version format (semantic versioning)
if [[ ! "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Version must be in format X.Y.Z (e.g., 1.0.1)"
    exit 1
fi

echo "Updating Xenofetch to version $NEW_VERSION..."

# Update xenofetch.sh
sed -i "s/XENOFETCH_VERSION=\"[^\"]*\"/XENOFETCH_VERSION=\"$NEW_VERSION\"/" xenofetch.sh
sed -i "s/# Version: [0-9.]*/# Version: $NEW_VERSION/" xenofetch.sh

# Update DEBIAN/control
sed -i "s/Version: [0-9.]*/Version: $NEW_VERSION/" DEBIAN/control

# Update PKGBUILD
sed -i "s/pkgver=[0-9.]*/pkgver=$NEW_VERSION/" PKGBUILD

# Update snap/snapcraft.yaml
sed -i "s/version: '[0-9.]*'/version: '$NEW_VERSION'/" snap/snapcraft.yaml

# Update xenofetch.nuspec
sed -i "s/<version>[0-9.]*<\/version>/<version>$NEW_VERSION<\/version>/" xenofetch.nuspec

# Update xenofetch.rb (Homebrew formula)
sed -i "s/version \"[0-9.]*\"/version \"$NEW_VERSION\"/" xenofetch.rb

# Update man page
sed -i "s/\"[0-9.]*\" \"xenofetch man page\"/\"$NEW_VERSION\" \"xenofetch man page\"/" xenofetch.1

# Update chocolateyinstall.ps1
sed -i "s/v[0-9.]*\.zip/v$NEW_VERSION.zip/" chocolateyinstall.ps1

echo "✅ Version updated to $NEW_VERSION in all files"
echo ""
echo "Next steps:"
echo "1. Review changes: git diff"
echo "2. Commit changes: git commit -am \"Bump version to $NEW_VERSION\""
echo "3. Create tag: git tag v$NEW_VERSION"
echo "4. Push with tags: git push origin main --tags"
echo "5. Create GitHub release with built packages"