{ stdenv, lib, fetchzip, fetchFromGitHub,
  pkgconfig, libsodium, libuv, libffi, python27 }:

# $ nix-prefetch-hg https://bitbucket.org/pypy/pypy
let
  pypySrc = fetchzip {
    url = "https://bitbucket.org/pypy/pypy/downloads/pypy2-v5.10.0-src.tar.bz2";
    sha256 = "11l1wpk2rk8m44jiwzvc8rqcbpnv3g348a2z017z2dhqfsc7a6af";
  };
  buildJIT = false;
  optLevel = if buildJIT then "-Ojit" else "-O2";
  python = python27.withPackages (ps: with ps; [ py pytest macropy ]);
in
stdenv.mkDerivation {
  name = "typhon-vm";
  version = "18.0.0";

  src = fetchFromGitHub {
    owner = "monte-language";
    repo = "typhon";
    rev = "beda6d6";
    sha256 = "1wbwhfv2a05c08f1rbsrcv2kpdd2ff1kmk3ji7w0ib2cd1a08jgj";
  };

  buildInputs = [ python pypySrc pkgconfig ];
  propagatedBuildInputs = [ libffi libuv libsodium ];

  buildPhase = ''
    source $stdenv/setup
    mkdir -p ./rpython/_cache
    cp -r ${pypySrc}/rpython .
    # RPython writes to here during translation.
    chmod -R u+w rpython/
    # cp $src/main.py .
    # Do the actual translation.
    ${python}/bin/python -mrpython ${optLevel} $src/main.py
    '';

  installPhase = ''
    mkdir -p $out/bin/
    cp mt-typhon $out/bin/
    '';
}
