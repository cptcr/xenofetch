class Xenofetch < Formula
  desc "Enhanced system information display tool with beautiful styling"
  homepage "https://github.com/cptcr/xenofetch"
  url "https://github.com/cptcr/xenofetch/archive/v1.0.0.tar.gz"
  sha256 "PLACEHOLDER_SHA256_WILL_BE_UPDATED_ON_RELEASE"
  license "MIT"
  version "1.0.0"

  depends_on "bash"

  def install
    # Install the main executable
    bin.install "xenofetch.sh" => "xenofetch"
    
    # Install main.sh to share directory
    (share/"xenofetch").install "main.sh"
    
    # Install man page if it exists
    man1.install "xenofetch.1" if File.exist?("xenofetch.1")
    
    # Install documentation
    doc.install "README.md", "LICENSE"
  end

  test do
    # Test that the command runs without error
    assert_match "Xenofetch", shell_output("#{bin}/xenofetch --help", 0)
  end

  def caveats
    <<~EOS
      Xenofetch has been installed!
      
      Run 'xenofetch' to display your system information.
      
      For more options, run:
        xenofetch --help
    EOS
  end
end