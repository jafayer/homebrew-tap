class NutritionRs < Formula
  desc "A CLI for flexible plaintext nutrition tracking"
  homepage "https://github.com/jafayer/nutrition-rs"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jafayer/nutrition-rs/releases/download/v0.2.0/nutrition_rs-aarch64-apple-darwin.tar.xz"
      sha256 "f4f84de64c29f5363d657b9f21db0471203bbb4b73960e961aaa93a95e952d06"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jafayer/nutrition-rs/releases/download/v0.2.0/nutrition_rs-x86_64-apple-darwin.tar.xz"
      sha256 "ff48cbe164493073580f662a1c70b110dcd4f96d9d10cdcee2fc35e508396fcf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jafayer/nutrition-rs/releases/download/v0.2.0/nutrition_rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a6330928caddf0231ad02ca70ac70aa84b97d33bb577a913fc944ea0e4e303e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jafayer/nutrition-rs/releases/download/v0.2.0/nutrition_rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "10fd3e0c31c7e5da338f6c5381a24e3d4b99a6e2376769ce89025b098ea2242d"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "nutrition" if OS.mac? && Hardware::CPU.arm?
    bin.install "nutrition" if OS.mac? && Hardware::CPU.intel?
    bin.install "nutrition" if OS.linux? && Hardware::CPU.arm?
    bin.install "nutrition" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
