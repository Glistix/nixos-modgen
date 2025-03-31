# modgen_test

[![Package Version](https://img.shields.io/hexpm/v/modgen_test)](https://hex.pm/packages/modgen_test)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/modgen_test/)

```sh
glistix add modgen_test@1
```
```gleam
import modgen_test

pub fn main() {
  // TODO: An example of the project in use
}
```

**Note:** This is a Glistix project, and as such may require the
[Glistix compiler](https://github.com/glistix/glistix) to be used.

Further documentation can be found at <https://hexdocs.pm/modgen_test>.

## Importing from Nix

To import this project from Nix, first fetch its source (through a Flake input,
using `builtins.fetchGit`, cloning to a local path, or some other way), import
the Flake or the `default.nix` file, and run `lib.loadGlistixPackage { }`.
For example:

```nix
let
  # Assuming the project was cloned to './path/to/project'
  modgen_test = import ./path/to/project;
  # Use 'loadGlistixPackage { module = "module/name"; }' to pick a module
  package = modgen_test.lib.loadGlistixPackage { };
  result = package.main { };
in result
```

## Development

```sh
nix develop   # Optional: Spawn a shell with glistix
glistix run   # Run the project
glistix test  # Run the tests
```

## License

Licensed under MIT or Apache-2.0, at your option.
