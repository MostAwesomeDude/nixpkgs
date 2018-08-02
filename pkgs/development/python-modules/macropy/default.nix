{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "MacroPy";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "lihaoyi";
    repo = "macropy";
    rev = "13993ccb08df21a0d63b091dbaae50b9dbb3fe3e";
    sha256 = "12496896c823h0849vnslbdgmn6z9mhfkckqa8sb8k9qqab7pyyl";
  };

  meta = {
    homepage = https://pypi.org/project/MacroPy/;
    description = "Macros for Python: Quasiquotes, Case Classes, LINQ and more!";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MostAwesomeDude ];
  };
}
