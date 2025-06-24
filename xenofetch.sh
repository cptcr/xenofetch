#!/bin/bash

# Xenofetch Enhanced - Ultimate System Information Display
# Version: 1.0.0
# Author: Anton Schmidt (cptcr)
# License: MIT

XENOFETCH_VERSION="1.0.0"

# Determine the location of main.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check multiple possible locations for main.sh
if [[ -f "$SCRIPT_DIR/main.sh" ]]; then
    # Development or local installation
    source "$SCRIPT_DIR/main.sh"
elif [[ -f "/usr/share/xenofetch/main.sh" ]]; then
    # Debian/Ubuntu installation
    source "/usr/share/xenofetch/main.sh"
elif [[ -f "/opt/xenofetch/main.sh" ]]; then
    # Alternative system installation
    source "/opt/xenofetch/main.sh"
elif [[ -f "$HOME/.xenofetch/main.sh" ]]; then
    # User installation
    source "$HOME/.xenofetch/main.sh"
elif [[ -f "/usr/local/share/xenofetch/main.sh" ]]; then
    # Homebrew installation
    source "/usr/local/share/xenofetch/main.sh"
else
    # If main.sh is not found, check if we're running the bundled version
    # This happens when the script is distributed as a single file
    
    # Check if main function exists (indicating bundled version)
    if ! declare -f main >/dev/null 2>&1; then
        echo "Error: Cannot find main.sh or the main function"
        echo "Please ensure xenofetch is properly installed"
        echo ""
        echo "Installation paths checked:"
        echo "  - $SCRIPT_DIR/main.sh"
        echo "  - /usr/share/xenofetch/main.sh"
        echo "  - /opt/xenofetch/main.sh"
        echo "  - $HOME/.xenofetch/main.sh"
        echo "  - /usr/local/share/xenofetch/main.sh"
        exit 1
    fi
fi

# If we get here and main function exists, run it
if declare -f main >/dev/null 2>&1; then
    main "$@"
else
    echo "Error: main function not found in main.sh"
    exit 1
fi