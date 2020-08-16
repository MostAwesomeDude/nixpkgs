{ mkDerivation, stdenv, perl, fetchdarcs, base }:
mkDerivation {
  pname = "pappy";
  version = "0.2-forked";
  src = fetchdarcs {
    url = "http://mbays.freeshell.org/pappy/";
    sha256 = "096zcvdchyv77y6jfaxxyq10xqsgl0xbwhr7k821cbzp1j9a7nag";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base ];
  description = "Packrat parsing; linear-time parsers for grammars in TDPL";
  license = stdenv.lib.licenses.bsd3;

  sourceRoot = "fetchdarcs/pappy";
  patchPhase = ''
    echo 'import Distribution.Make; main = defaultMain' > Setup.hs
    echo '#!/bin/sh' > configure; chmod +x configure
  '';
  buildTools = [ perl ];
  doCheck = false;
  doHaddock = false;
  installPhase = ''
    mkdir -p $out/bin/
    cp pappy $out/bin/
  '';
}
