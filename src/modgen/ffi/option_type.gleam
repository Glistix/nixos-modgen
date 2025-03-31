import gleam/dynamic.{type Dynamic}
import modgen/ffi.{type OptionType}

/// Get the type's name.
@external(nix, "../../option_type_ffi.nix", "name")
pub fn name(type_: OptionType) -> String

/// Get the type's description.
@external(nix, "../../option_type_ffi.nix", "description")
pub fn description(type_: OptionType) -> String

/// Check whether a value satisfies this type's constraints.
@external(nix, "../../option_type_ffi.nix", "check")
pub fn check(type_: OptionType, value: Dynamic) -> Bool
