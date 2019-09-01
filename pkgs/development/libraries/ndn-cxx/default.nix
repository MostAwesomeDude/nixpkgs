{ stdenv, fetchFromGitHub, openssl, doxygen
, boost, sqlite, pkgconfig, python, pythonPackages, wafHook }:
let
  version = "0.6.6";
in
stdenv.mkDerivation {
  pname = "ndn-cxx";
  inherit version;
  src = fetchFromGitHub {
    owner = "named-data";
    repo = "ndn-cxx";
    rev = "ndn-cxx-${version}";
    sha256 = "06q4bsl63bn5h9csdyz883qpak67511w5d7xl3z5364pmjfwvji2";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ openssl doxygen boost sqlite python pythonPackages.sphinx];
  wafConfigureFlags = [
    "--with-openssl=${openssl.dev}"
    "--boost-includes=${boost.dev}/include"
    "--boost-libs=${boost.out}/lib"
    # Building the tests is disabled by default, since we don't run the tests
    # later and building them adds ~14min to build time. ~ C.
    # "--with-tests"
  ];

  # Upstream's tests don't all pass!
  doCheck = false;
  checkPhase = ''
    LD_LIBRARY_PATH=build/ build/unit-tests
  '';

  outputs = [ "dev" "out" ];

  meta = with stdenv.lib; {
    homepage = "http://named-data.net/";
    description = "A Named Data Neworking (NDN) or Content Centric Networking (CCN) abstraction";
    longDescription = ''
      ndn-cxx is a C++ library, implementing Named Data Networking (NDN)
      primitives that can be used to implement various NDN applications.
      NDN operates by addressing and delivering Content Objects directly
      by Name instead of merely addressing network end-points. In addition,
      the NDN security model explicitly secures individual Content Objects
      rather than securing the connection or “pipe”. Named and secured
      content resides in distributed caches automatically populated on
      demand or selectively pre-populated. When requested by name, NDN
      delivers named content to the user from the nearest cache, thereby
      traversing fewer network hops, eliminating redundant requests,
      and consuming less resources overall.
    '';
    license = licenses.lgpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with maintainers; [ sjmackenzie MostAwesomeDude ];
  };
}
