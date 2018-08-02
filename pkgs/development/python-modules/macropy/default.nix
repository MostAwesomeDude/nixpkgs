{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "MacroPy";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0yqiy1ij823x1mifiba8szibw0nvva6fw7zfn5gn5nw7k055arz6";
  };

  meta = {
    homepage = https://pypi.org/project/MacroPy/;
    description = "Macros for Python: Quasiquotes, Case Classes, LINQ and more!";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MostAwesomeDude ];
  };
}
