import gleam/dynamic.{
  type DecodeError, type DecodeErrors, type Decoder, type Dynamic, DecodeError,
}
import gleam/result
import glistix/nix
import glistix/nix/attrset.{type AttrSet}

pub type ModuleOption

pub type OptionType

/// The type of a nixpkgs lib object.
type LibObjectType {
  /// This is an option.
  OptionLibType
  /// This is an option's type.
  OptionTypeLibType
}

@external(nix, "../ffi_ffi.nix", "identity")
fn unsafe_cast(dyn: Dynamic) -> a

fn decode_attrset(object: Dynamic) -> Result(AttrSet(Dynamic), DecodeErrors) {
  case nix.typeof(object) {
    nix.SetType -> {
      Ok(unsafe_cast(object))
    }
    _ -> Error([])
  }
}

@external(nix, "../ffi_ffi.nix", "get_lib_obj_type")
fn get_lib_object_type_raw(object: Dynamic) -> String

/// Get an object's type within nixpkgs.lib, if possible.
fn get_lib_object_type(object: Dynamic) -> Result(LibObjectType, Nil) {
  case get_lib_object_type_raw(object) {
    "option" -> Ok(OptionLibType)
    "option-type" -> Ok(OptionTypeLibType)
    _ -> Error(Nil)
  }
}

pub fn decode_module_option(
  object: Dynamic,
) -> Result(ModuleOption, DecodeErrors) {
  case get_lib_object_type(object) {
    Ok(OptionLibType) -> Ok(unsafe_cast(object))
    Ok(OptionTypeLibType) ->
      Error([
        DecodeError(expected: "module option", found: "option type", path: []),
      ])
    Error(Nil) ->
      Error([DecodeError(expected: "module option", found: "unknown", path: [])])
  }
}

pub fn decode_option_type(object: Dynamic) -> Result(OptionType, DecodeErrors) {
  case get_lib_object_type(object) {
    Ok(OptionTypeLibType) -> Ok(unsafe_cast(object))
    Ok(OptionLibType) ->
      Error([
        DecodeError(expected: "option type", found: "module option", path: []),
      ])
    Error(Nil) ->
      Error([DecodeError(expected: "option type", found: "unknown", path: [])])
  }
}
