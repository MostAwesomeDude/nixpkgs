{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  version = "0.16.1";
  name = "runbook-${version}";

  inherit ruby;
  gemdir = ./.;

  meta = with lib; {
    description = "Runbook provides a DSL for specifying system operations.";
    homepage    = https://github.com/braintree/runbook;
    license     = with licenses; mit;
    maintainers = with maintainers; [ MostAwesomeDude ];
    platforms   = platforms.unix;
  };
}
