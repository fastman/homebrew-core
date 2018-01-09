class Openalpr < Formula
  desc "Automatic License Plate Recognition library"
  homepage "https://github.com/openalpr/openalpr"
  url "https://github.com/openalpr/openalpr/archive/v2.3.0.tar.gz"
  sha256 "1cfcaab6f06e9984186ee19633a949158c0e2aacf9264127e2f86bd97641d6b9"

  head "https://github.com/openalpr/openalpr.git", :branch => "master"

  option "without-daemon", "Do not include the alpr daemon (alprd)"

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "tesseract"
  depends_on "opencv@2"

  if build.with? "daemon"
    depends_on "log4cplus"
    depends_on "beanstalkd"
  end

  def install
    mkdir "src/build" do
      args = std_cmake_args

      args << "-DCMAKE_MACOSX_RPATH=true"
      args << "-DCMAKE_INSTALL_SYSCONFDIR=/usr/local/etc/openalpr"

      if build.without? "daemon"
        if build.head?
          args << "-DWITH_DAEMON=NO"
        else
          args << "-DWITHOUT_DAEMON=YES"
        end
      end

      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    actual = `#{bin}/alpr #{HOMEBREW_PREFIX}/Library/Homebrew/test/fixtures/test.jpg`
    assert_equal "No license plates found.\n", actual, "output from reading test JPG image"
  end
end
