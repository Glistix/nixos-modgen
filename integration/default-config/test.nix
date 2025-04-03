let
  proj = import ../..;
  lib = proj.inputs.nixpkgs.lib;
  pkgs = import proj.inputs.nixpkgs { };
  integ_test = proj.lib.loadGlistixPackage { output = ../../build; module = "gen_integ_test"; };
in integ_test.gen_system lib pkgs [ ./configuration.nix ]
