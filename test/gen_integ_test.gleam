import glistix/nix/array.{type Array}
import glistix/nix/env
import glistix/nix/path.{type Path}
import glistix/nix/system.{type System}
import modgen/ffi/module_eval.{type ModuleEval}
import modgen/gen

pub type Nixpkgs

pub type NixpkgsLib

@external(nix, "./gen_integ_test_ffi.nix", "pkgsLib")
fn lib(pkgs: Nixpkgs) -> NixpkgsLib

@external(nix, "./gen_integ_test_ffi.nix", "nixosSystem")
fn nixos_system(
  lib: NixpkgsLib,
  pkgs: Nixpkgs,
  system: System,
  modules: Array(Path),
) -> ModuleEval

pub fn gen_system(lib: NixpkgsLib, pkgs: Nixpkgs, modules: Array(Path)) {
  let assert Ok(current_system) = env.current_system()
  let modules =
    lib
    |> nixos_system(pkgs, current_system, modules)

  gen.from_eval(modules)
}
