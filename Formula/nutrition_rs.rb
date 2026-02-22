class NutritionRs < Formula
  desc "A CLI for flexible plaintext nutrition tracking"
  homepage "https://github.com/jafayer/nutrition-rs"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jafayer/nutrition-rs/releases/download/v0.1.0/nutrition_rs-aarch64-apple-darwin.tar.xz"
      sha256 "0e0e269418020e31d2a7577dd830f2b1f80c4f2849e2c5d04feb00367f87e713"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jafayer/nutrition-rs/releases/download/v0.1.0/nutrition_rs-x86_64-apple-darwin.tar.xz"
      sha256 "2ca01d4b90a32ef279ac0e9f624d6bec9c5a8914acc7a4c2505716d03e0cabb0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jafayer/nutrition-rs/releases/download/v0.1.0/nutrition_rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3c3598fcfaff5f2160ce52cd851e0ccdb6d6806cbfa792d9c08333d053d4a67e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jafayer/nutrition-rs/releases/download/v0.1.0/nutrition_rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "296164d937f6b5eaecb6a2ba81d0bd5f3ae146c64f56a03821d1d7982b1d674b"
    end
  end

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
