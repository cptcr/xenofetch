#!/bin/bash

# Xenofetch Universal Installer
# Automatically detects and uses the best package manager for your system

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

REPO_URL="https://github.com/cptcr/xenofetch"
REPO_OWNER="cptcr"
REPO_NAME="xenofetch"

# Get latest version from GitHub API
get_latest_version() {
    local latest_url="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest"
    local version=""
    
    if command -v curl >/dev/null 2>&1; then
        version=$(curl -s "$latest_url" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/^v//')
    elif command -v wget >/dev/null 2>&1; then
        version=$(wget -qO- "$latest_url" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/^v//')
    fi
    
    if [[ -z "$version" ]]; then
        version="1.0.0"  # Fallback version
        warn "Could not fetch latest version, using fallback: $version"
    else
        log "Latest version detected: $version"
    fi
    
    echo "$version"
}

# Fancy banner
print_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║    ██╗  ██╗███████╗███╗   ██╗ ██████╗ ███████╗███████╗  ║
    ║    ╚██╗██╔╝██╔════╝████╗  ██║██╔═══██╗██╔════╝██╔════╝  ║
    ║     ╚███╔╝ █████╗  ██╔██╗ ██║██║   ██║█████╗  ███████╗  ║
    ║     ██╔██╗ ██╔══╝  ██║╚██╗██║██║   ██║██╔══╝  ╚════██║  ║
    ║    ██╔╝ ██╗███████╗██║ ╚████║╚██████╔╝██║     ███████║  ║
    ║    ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚══════╝  ║
    ║                                                           ║
    ║              Enhanced System Information Tool             ║
    ║                                                           ║
    ╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

log() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

# Detect OS and package manager
detect_system() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian) echo "debian" ;;
            fedora|centos|rhel) echo "fedora" ;;
            arch|manjaro) echo "arch" ;;
            *) echo "linux" ;;
        esac
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Install using Homebrew
install_homebrew() {
    log "Installing via Homebrew..."
    
    if ! command -v brew >/dev/null 2>&1; then
        log "Installing Homebrew first..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    # Add tap if not already added
    brew tap cptcr/xenofetch 2>/dev/null || true
    brew install xenofetch
    success "Installed via Homebrew!"
}

# Install using APT (Debian/Ubuntu)
install_apt() {
    log "Installing via APT..."
    
    local version=$(get_latest_version)
    local deb_url="${REPO_URL}/releases/download/v${version}/xenofetch_${version}_all.deb"
    local temp_file=$(mktemp)
    
    log "Downloading .deb package (v${version})..."
    curl -fsSL "$deb_url" -o "$temp_file"
    
    log "Installing package..."
    sudo dpkg -i "$temp_file" || {
        log "Fixing dependencies..."
        sudo apt-get update
        sudo apt-get install -f -y
    }
    
    rm -f "$temp_file"
    success "Installed via APT!"
}

# Install using Snap
install_snap() {
    log "Installing via Snap..."
    
    if ! command -v snap >/dev/null 2>&1; then
        error "Snap is not installed on this system"
    fi
    
    sudo snap install xenofetch
    success "Installed via Snap!"
}

# Install using Pacman (Arch Linux)
install_pacman() {
    log "Installing via Pacman..."
    
    # Check if it's available in AUR
    if command -v yay >/dev/null 2>&1; then
        yay -S xenofetch
    elif command -v paru >/dev/null 2>&1; then
        paru -S xenofetch
    else
        log "Installing manually from PKGBUILD..."
        local temp_dir=$(mktemp -d)
        cd "$temp_dir"
        
        curl -fsSL "${REPO_URL}/releases/download/v${VERSION}/PKGBUILD" -o PKGBUILD
        curl -fsSL "${REPO_URL}/archive/v${VERSION}.tar.gz" -o "xenofetch-${VERSION}.tar.gz"
        
        makepkg -si --noconfirm
        cd - >/dev/null
        rm -rf "$temp_dir"
    fi
    
    success "Installed via Pacman!"
}

# Install using Chocolatey (Windows)
install_chocolatey() {
    log "Installing via Chocolatey..."
    
    if ! command -v choco >/dev/null 2>&1; then
        log "Installing Chocolatey first..."
        powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    fi
    
    choco install xenofetch -y
    success "Installed via Chocolatey!"
}

# Manual installation (fallback)
install_manual() {
    log "Installing manually..."
    
    local install_dir="$HOME/.local/bin"
    
    # Create install directory
    mkdir -p "$install_dir"
    
    # Download script
    log "Downloading xenofetch..."
    curl -fsSL "${REPO_URL}/raw/main/xenofetch.sh" -o "${install_dir}/xenofetch"
    chmod +x "${install_dir}/xenofetch"
    
    # Check if directory is in PATH
    if [[ ":$PATH:" != *":$install_dir:"* ]]; then
        warn "Adding $install_dir to PATH..."
        
        # Determine shell config file
        if [[ -n "$ZSH_VERSION" ]]; then
            shell_config="$HOME/.zshrc"
        elif [[ -n "$BASH_VERSION" ]]; then
            shell_config="$HOME/.bashrc"
        else
            shell_config="$HOME/.profile"
        fi
        
        echo 'export PATH="$PATH:$HOME/.local/bin"' >> "$shell_config"
        warn "Please run: source $shell_config"
        warn "Or restart your terminal to use xenofetch"
    fi
    
    success "Installed manually to $install_dir/xenofetch!"
}

# Main installation logic
main() {
    print_banner
    
    local version=$(get_latest_version)
    log "Xenofetch Universal Installer - Installing v${version}"
    log "Detecting your system..."
    
    local system=$(detect_system)
    local installed=false
    
    log "Detected system: $system"
    
    case "$system" in
        macos)
            if command -v brew >/dev/null 2>&1; then
                install_homebrew && installed=true
            else
                log "Homebrew not found, trying manual installation..."
                install_manual && installed=true
            fi
            ;;
        debian)
            if command -v apt >/dev/null 2>&1 && [[ $EUID -eq 0 ]] || sudo -n true 2>/dev/null; then
                install_apt && installed=true
            elif command -v snap >/dev/null 2>&1; then
                install_snap && installed=true
            else
                install_manual && installed=true
            fi
            ;;
        arch)
            if command -v pacman >/dev/null 2>&1; then
                install_pacman && installed=true
            else
                install_manual && installed=true
            fi
            ;;
        windows)
            if command -v choco >/dev/null 2>&1; then
                install_chocolatey && installed=true
            else
                install_manual && installed=true
            fi
            ;;
        *)
            log "Unknown system, trying manual installation..."
            install_manual && installed=true
            ;;
    esac
    
    if [[ "$installed" == true ]]; then
        echo
        success "🎉 Xenofetch has been installed successfully!"
        echo
        echo -e "${CYAN}Usage:${NC}"
        echo -e "  ${GREEN}xenofetch${NC}          - Show system information"
        echo -e "  ${GREEN}xenofetch --help${NC}   - Show help message"
        echo -e "  ${GREEN}xenofetch --no-logo${NC} - Hide distro logo"
        echo
        echo -e "${PURPLE}Try running: ${GREEN}xenofetch${NC}"
        echo
    else
        error "Installation failed. Please check the error messages above."
    fi
}

# Help message
if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    print_banner
    echo "Xenofetch Universal Installer"
    echo
    echo "This script automatically detects your system and installs Xenofetch"
    echo "using the most appropriate package manager:"
    echo
    echo "  macOS     → Homebrew"
    echo "  Debian    → APT (.deb packages)"
    echo "  Ubuntu    → APT or Snap"
    echo "  Arch      → Pacman (AUR)"
    echo "  Windows   → Chocolatey"
    echo "  Other     → Manual installation"
    echo
    echo "Usage:"
    echo "  curl -fsSL https://raw.githubusercontent.com/cptcr/xenofetch/main/install.sh | bash"
    echo
    exit 0
fi

# Check for required tools
if ! command -v curl >/dev/null 2>&1; then
    error "curl is required but not installed"
fi

# Run main installation
main "$@"