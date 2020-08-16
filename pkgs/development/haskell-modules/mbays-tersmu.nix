{ mkDerivation, stdenv, fetchgit,
  base, mbays-pappy, containers, mtl, network, process, regex-posix, syb, transformers }:
mkDerivation {
  pname = "tersmu";
  version = "0.2.2-git";
  src = fetchgit {
    url = "https://gitlab.com/zugz/tersmu.git";
    rev = "577e4533c463a5e5001dd4e90c1a0f0199af6f4d";
    sha256 = "1x00rqfs2l85v83wjpk92p3qrg2rf49rdgvh81ngygabkb2rfjwk";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base containers mtl network process regex-posix syb transformers
  ];
  executableHaskellDepends = [
    base containers mtl network process regex-posix syb transformers
  ];
  description = "A semantic parser for lojban";
  license = stdenv.lib.licenses.gpl3;

  patchPhase = ''
    echo 'import Distribution.Make; main = defaultMain' > Setup.hs
    echo '#!/bin/sh' > configure; chmod +x configure
    sed -i -e 's,PAPPY=.*,PAPPY=${mbays-pappy}/bin/pappy,' Makefile
    # tersmuBot.hs isn't compatible with network 3.x.x.x!
    sed -i -e 's,^all:.*,all: tersmu,' Makefile
  '';
  doCheck = false;
  doHaddock = false;
  installPhase = ''
    mkdir -p $out/bin/
    cp tersmu $out/bin/
  '';
}
