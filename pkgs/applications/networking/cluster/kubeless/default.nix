{ buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  name = "kubeless-${version}";
  version = "1.0.0-alpha.7";

  goPackagePath = "github.com/kubeless/kubeless";
  subPackages = [ "cmd/kubeless" ];

  src = fetchFromGitHub {
    owner = "kubeless";
    repo = "kubeless";
    rev = "v${version}";
    sha256 = "00fwc0c2cq3bmpwmx0g0jz1grrmki5majnrnzj4w7hcl7aw5hzh0";
  };
}
