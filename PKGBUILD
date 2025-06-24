# Maintainer: Anton Schmidt <cptcr@proton.me>
pkgname=xenofetch
pkgver=1.0.0
pkgrel=1
pkgdesc="Enhanced system information display tool with beautiful styling"
arch=('any')
url="https://github.com/cptcr/xenofetch"
license=('MIT')
depends=('bash' 'coreutils' 'grep' 'gawk' 'sed' 'procps-ng')
optdepends=(
    'lspci: for GPU information'
    'curl: for public IP detection'
    'lm_sensors: for temperature information'
    'xorg-xrandr: for display resolution detection'
    'net-tools: for additional network information'
    'util-linux: for enhanced system information'
)
source=("$pkgname-$pkgver.tar.gz::https://github.com/cptcr/$pkgname/archive/v$pkgver.tar.gz")
sha256sums=('SKIP')

package() {
    cd "$pkgname-$pkgver"
    
    # Install the main script
    install -Dm755 xenofetch.sh "$pkgdir/usr/bin/xenofetch"
    
    # Install the main logic file
    install -Dm644 main.sh "$pkgdir/usr/share/$pkgname/main.sh"
    
    # Install documentation
    install -Dm644 README.md "$pkgdir/usr/share/doc/$pkgname/README.md"
    
    # Install license
    install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
    
    # Install man page if it exists
    if [ -f xenofetch.1 ]; then
        install -Dm644 xenofetch.1 "$pkgdir/usr/share/man/man1/xenofetch.1"
    fi
}