{ stdenv, pkgs, lib, typhon }:

stdenv.mkDerivation {
    name = "monte-mast";
    version = "18.0.0";

    src = typhon.src;

    buildInputs = [ typhon ];

    buildPhase = ''
      ln -s ${typhon}/bin/mt-typhon .
      make
      '';

    doCheck = true;
    checkPhase = "make testMast";

    installPhase = ''
      mkdir -p $out/
      cp -r mast/ loader.mast $out/
      '';
}
