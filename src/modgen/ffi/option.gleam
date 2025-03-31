import glistix/nix/array.{type Array}
import modgen/ffi.{type ModuleOption, type OptionType}

/// Get the option's type.
@external(nix, "../../option_ffi.nix", "option_type")
pub fn type_(option: ModuleOption) -> OptionType

/// Get the option's description.
@external(nix, "../../option_ffi.nix", "option_description")
pub fn description(option: ModuleOption) -> String

/// Get the option's location from the top of the config.
///
/// Note that this isn't something inherent to the option,
/// and may vary per config.
@external(nix, "../../option_ffi.nix", "loc")
pub fn locate(option: ModuleOption) -> Array(String)
