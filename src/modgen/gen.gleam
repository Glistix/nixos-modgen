import gleam/dynamic.{type Dynamic}
import gleam/io
import gleam/string
import glistix/nix/array.{type Array}
import glistix/nix/attrset.{type AttrSet}
import modgen/ffi.{type ModuleOption, type OptionType}
import modgen/ffi/module_eval.{type ModuleEval, type OptionTree, Leaf, Subtree}
import modgen/ffi/option as module_option
import modgen/ffi/option_type

type TreeTraversalResult {
  TreeTraversalResult(subtrees: AttrSet(Dynamic), code: String)
}

const preamble = "import gleam/dynamic.{type Dynamic}\nimport glistix/nix/attrset.{type AttrSet}\n\n"

fn camel_to_snake_case_aux(string: String, is_first: Bool) -> String {
  case string.pop_grapheme(string) {
    Ok(#(letter, rest)) -> {
      let lower = string.lowercase(letter)
      case letter == lower {
        True -> letter <> camel_to_snake_case_aux(rest, False)
        False if is_first -> lower <> camel_to_snake_case_aux(rest, False)
        False -> "_" <> lower <> camel_to_snake_case_aux(rest, False)
      }
    }
    Error(Nil) -> string
  }
}

fn camel_to_snake_case(string: String) -> String {
  camel_to_snake_case_aux(string, True)
}

/// Perform codegen based on a module evaluation.
pub fn from_eval(eval_result: ModuleEval) -> AttrSet(Dynamic) {
  let options_root =
    eval_result
    |> module_eval.options

  let traversed_options =
    options_root
    |> traverse_option_tree

  traversed_options.subtrees
}

fn traverse_option_tree(tree: OptionTree) -> TreeTraversalResult {
  use acc, node <- array.fold(
    module_eval.traverse_option_tree(tree),
    TreeTraversalResult(attrset.new(), ""),
  )

  case node {
    #(name, Subtree(subtree)) -> {
      let traversed_data = traverse_option_tree(subtree)

      let name_ident = camel_to_snake_case(name)

      // Only add subtrees if there were actually subtrees
      let updated_attrs = case traversed_data.subtrees == attrset.new() {
        True -> acc.subtrees

        False ->
          acc.subtrees
          |> attrset.set(name_ident, dynamic.from(traversed_data.subtrees))
      }

      let updated_attrs = case traversed_data.code {
        "" -> updated_attrs
        code ->
          updated_attrs
          |> attrset.set(name_ident <> ".gleam", dynamic.from(preamble <> code))
      }

      TreeTraversalResult(..acc, subtrees: updated_attrs)
    }
    #(name, Leaf(option)) ->
      TreeTraversalResult(..acc, code: acc.code <> codegen(name, option))
  }
}

fn codegen_type(type_: OptionType) -> String {
  case type_ |> option_type.name {
    "int" -> "Int"
    "str" -> "String"
    "bool" -> "Bool"
    "float" -> "Float"
    "attrs" -> "AttrSet(Dynamic)"
    _ -> "Dynamic"
  }
}

fn codegen_docstring(docs: String) -> String {
  case docs {
    "" -> ""
    docs ->
      "/// "
      <> { docs |> string.trim |> string.replace(each: "\n", with: "\n/// ") }
      <> "\n"
  }
}

fn codegen(name: String, option: ModuleOption) -> String {
  let name_ident =
    name
    |> camel_to_snake_case

  let description =
    module_option.description(option)
    |> codegen_docstring

  let type_ =
    module_option.type_(option)
    |> codegen_type

  let get_fun =
    description
    <> "pub fn get_"
    <> name_ident
    <> "(config: AttrSet("
    <> type_
    <> ")) -> Result("
    <> type_
    <> ", Nil) {\n"
    <> "  attrset.get(config, \""
    <> name
    <> "\")\n}\n"

  let set_fun =
    description
    <> "pub fn set_"
    <> name_ident
    <> "(config: AttrSet(Dynamic), value: "
    <> type_
    <> ") -> AttrSet(Dynamic) {\n"
    <> "  attrset.set(config, \""
    <> name
    <> "\", dynamic.from(value))\n}\n"

  get_fun <> "\n" <> set_fun
}
