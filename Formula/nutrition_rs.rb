class NutritionRs < Formula
  desc "A CLI for flexible plaintext nutrition tracking"
  homepage "https://github.com/jafayer/nutrition-rs"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jafayer/nutrition-rs/releases/download/v0.1.2/nutrition_rs-aarch64-apple-darwin.tar.xz"
      sha256 "0cefb28ed30728a6dfcb2796e0433f8097f95ca06a8338ec15037b6ae0f4bd23"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jafayer/nutrition-rs/releases/download/v0.1.2/nutrition_rs-x86_64-apple-darwin.tar.xz"
      sha256 "34abe955eed2538050ba34c3ad2ec752edd19b363915f150aa7deded459ba5c9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jafayer/nutrition-rs/releases/download/v0.1.2/nutrition_rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7758151e1233495e7a7f7a52fb644e34f55b3c161fd49bb5eb2864c6072ee468"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jafayer/nutrition-rs/releases/download/v0.1.2/nutrition_rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "16ee041a0081629789581a5dc1b01647f60cca56e78e2df163d56e1a8aa4ec99"
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
