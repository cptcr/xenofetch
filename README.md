# Xenofetch

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/release/cptcr/xenofetch.svg)](https://github.com/cptcr/xenofetch/releases)
[![Downloads](https://img.shields.io/github/downloads/cptcr/xenofetch/total.svg)](https://github.com/cptcr/xenofetch/releases)

Enhanced system information display tool with beautiful styling and comprehensive hardware detection.

![Xenofetch Demo](https://github.com/cptcr/xenofetch/raw/main/demo.png)

## Features

- **Stunning Visual Output** - Gradient-colored tables with ASCII art and distribution logos
- **Comprehensive Detection** - CPU specs, GPU details, memory usage, storage devices, network interfaces  
- **Real-time Monitoring** - Process analysis, temperature sensors, battery status, system load
- **Cross-Platform Support** - Native support for Linux, macOS, and Windows (WSL/Git Bash)
- **Lightweight Design** - Pure bash implementation with minimal system overhead
- **Network Diagnostics** - Public IP detection, DNS configuration, interface analysis
- **Smart Adaptation** - Automatic color schemes based on your Linux distribution
- **Extensive Hardware Support** - Multi-GPU detection, motherboard info, BIOS details

## Quick Install

### One-Line Install (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/cptcr/xenofetch/main/install.sh | bash
```

### Package Managers

#### Homebrew (macOS/Linux)
```bash
brew tap cptcr/xenofetch
brew install xenofetch
```

#### Chocolatey (Windows)
```powershell
choco install xenofetch
```

#### APT (Debian/Ubuntu)
```bash
wget https://github.com/cptcr/xenofetch/releases/latest/download/xenofetch_1.0.0_all.deb
sudo dpkg -i xenofetch_1.0.0_all.deb
```

#### Snap (Universal Linux)
```bash
sudo snap install xenofetch
```

#### Pacman (Arch Linux)
```bash
# Using AUR helper
yay -S xenofetch

# Or manual installation
wget https://github.com/cptcr/xenofetch/releases/latest/download/PKGBUILD
makepkg -si
```

## Usage

```bash
# Display system information
xenofetch

# Hide distro logo
xenofetch --no-logo

# Show help
xenofetch --help
```

## System Information Displayed

### Core System Info
- **Operating System** - Distribution, version, and architecture details
- **Kernel Information** - Version, build date, and system architecture  
- **Host Machine** - Manufacturer, model, and hardware identification
- **System Uptime** - Boot time and current session duration
- **Package Inventory** - Comprehensive count across all package managers
- **Shell Environment** - Current shell, version, and terminal information

### Hardware Detection
- **CPU Specifications** - Model, frequency, core count, and architecture
- **Memory Analysis** - Usage statistics, available RAM, and swap information
- **Storage Devices** - Disk information, storage capacity, and device types
- **Graphics Cards** - Multi-GPU support with detailed specifications
- **Battery Status** - Power level, charging state, and health information
- **Temperature Monitoring** - System thermal data and sensor readings

### Network & Connectivity
- **IP Address Detection** - Public and local network addressing
- **Interface Analysis** - Active network adapters and connection status
- **DNS Configuration** - Server settings and resolution capabilities
- **Network Topology** - Domain information and hostname details

### Process & Performance
- **Process Statistics** - Running application count and system load
- **Resource Monitoring** - Top CPU and memory consuming processes
- **Performance Metrics** - Load averages and system utilization
- **Real-time Analysis** - Dynamic resource consumption tracking

### Environment & Locale
- **System Configuration** - Locale settings and internationalization
- **Time Zone Information** - Current timezone and synchronization status
- **User Sessions** - Currently logged-in users and session details
- **Hardware Vendor** - System manufacturer and BIOS information

## Visual Customization

Xenofetch automatically detects your distribution and applies beautiful color schemes:

- Arch Linux - Blue and cyan gradients with modern styling
- Ubuntu - Orange and red themes reflecting brand colors
- Debian - Red and pink styling with classic aesthetics
- Kali Linux - Purple and blue colors for security-focused design
- Fedora - Blue and white scheme matching project branding
- macOS - Clean white and cyan styling for elegant presentation

## Dependencies

### Required Components
- `bash` (4.0+) - Core shell environment
- `coreutils` - Standard Unix utilities

### Optional Enhancements
- `lspci` - Detailed GPU information and PCI device detection
- `curl` - Public IP detection and network connectivity testing
- `lm-sensors` - Temperature monitoring and thermal sensor data
- `xorg-xrandr` - Display resolution detection in X11 environments
- `util-linux` - Enhanced system information gathering
- `procps-ng` - Advanced process monitoring capabilities
- `net-tools` - Additional network interface information

## Building Packages

To build all package formats for distribution:

```bash
chmod +x build-packages.sh
./build-packages.sh
```

This creates packages for:
- Debian (.deb) - APT package manager
- Arch Linux (tarball + PKGBUILD) - Pacman/AUR
- Snap (.snap) - Universal Linux packages  
- Chocolatey (.nupkg) - Windows package manager

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by neofetch and other system information tools
- Thanks to all contributors and users who make this project possible
- Built with love for the open source community

## Support & Contact

- **Issues**: [Report bugs](https://github.com/cptcr/xenofetch/issues)
- **Discussions**: [Community forum](https://github.com/cptcr/xenofetch/discussions)
- **Website**: [https://cptcr.dev](https://cptcr.dev)
- **Email**: [cptcr@proton.me](mailto:cptcr@proton.me)
- **Contact**: [https://cptcr.dev/contact](https://cptcr.dev/contact)

---

**Made with love by [Anton Schmidt](https://cptcr.dev)**