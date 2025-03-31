import gleam/dynamic.{type Dynamic}
import glistix/nix/array.{type Array}
import glistix/nix/attrset.{type AttrSet}
import modgen/ffi.{type ModuleOption}

/// The result of calling `lib.evalModules`.
pub type ModuleEval

pub type OptionTree

pub type OptionTreeNode {
  Subtree(OptionTree)
  Leaf(ModuleOption)
}

@external(nix, "../../ffi_ffi.nix", "identity")
fn unsafe_cast(input: a) -> b

/// Gets all options in this module eval, as a tree.
@external(nix, "../../module_eval_ffi.nix", "options")
pub fn options(eval: ModuleEval) -> OptionTree

/// Visualize all the children in an option tree.
pub fn traverse_option_tree(
  tree: OptionTree,
) -> Array(#(String, OptionTreeNode)) {
  let tree_set: AttrSet(Dynamic) = unsafe_cast(tree)

  tree_set
  |> attrset.to_array
  |> array.map(fn(pair) {
    let #(name, value) = pair
    case ffi.decode_module_option(value) {
      Ok(option) -> #(name, Leaf(option))
      Error(_) -> #(name, Subtree(unsafe_cast(value)))
    }
  })
}
