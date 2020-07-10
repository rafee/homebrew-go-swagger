class GoSwagger < Formula
  desc "Toolkit to work with swagger for golang"
  homepage "https://github.com/go-swagger/go-swagger"
  @@version = "0.24.0"
  version @@version
  @@os = nil
  @@arch = nil
  @@sha256Map = {}

  resource "sha_text" do
    url "https://github.com/go-swagger/go-swagger/releases/download/v#{@@version}/sha256sum.txt"
    sha256 "0e879d6399c3ab01b0adc8640e9b98e980d6acba45731642790c0873af4b3eab"
  end

  if OS.mac?
    @@os = "darwin"
    case RbConfig::CONFIG["host_cpu"]
    when "i386"
      @@arch = "386"
    when "x86_64"
      @@arch = "amd64"
    else
      ohdie "This architecture isn't officially supported by this formula. If this is supported by golang, feel free to visit our repo and compile from source"
    end
  elsif OS.linux?
    @@os = "linux"
    case RbConfig::CONFIG["host_cpu"]
    when "arm"
      @@arch = "arm"
    when "aarch64"
      @@arch = "arm64"
    when "x86_64"
      @@arch = "amd64"
    when "i386"
      @@arch = "386"
    else
      ohdie "This architecture isn't officially supported by this formula. If this is supported by golang, feel free to visit our repo and compile from source"
    end
  else
    ohdie "This operating system isn't officially supported by this formula. If this is supported by golang, feel free to visit our repo and compile from source"
  end

  @@filename = "swagger_#{@@os}_#{@@arch}"
  url "https://github.com/go-swagger/go-swagger/releases/download/v#{@@version}/#{@@filename}"
  sha256 @@sha256Map[@@filename]

  option "with-goswagger", "Names the binary goswagger instead of swagger"

  def install
    resource("sha_text").stage { bin.install "sha256.txt" }
    File.open("sha256sum.txt", "r") do |file|
      file.each_line do |line|
        line_data = line.split(" ")
        puts line_data
        @@sha256Map[line_data[1]] = line_data[0]
      end
    end
    nm = "swagger"
    if build.with? "goswagger"
      nm = "goswagger"
    end
    system "mv", @@filename, nm
    bin.install nm
  end

  test do
    if build.with? "goswagger"
      system "#{bin}/goswagger", "version"
    else
      system "#{bin}/swagger", "version"
    end
  end
end
