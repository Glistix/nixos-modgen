let
  pkgsLib = pkgs: pkgs.lib;
  nixosSystem = lib: pkgs: system: modules: lib.nixosSystem { inherit lib pkgs system modules; };
in { inherit pkgsLib nixosSystem; }
