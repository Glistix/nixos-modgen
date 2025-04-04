# nixos-modgen (WIP)

A **work in progress** Gleam binding generator for NixOS modules, to be used in Glistix.

## This is work in progress (WIP)

This is a work in progress [Glistix project](https://github.com/glistix/glistix). The intention of this repository is to attract interested contributors!

We discuss progress in our Zulip, such as in [this thread.](https://glistix.zulipchat.com/#narrow/channel/453881-general/topic/NixOS.20binding.20generator.20contribution/with/510046966) Feel free to join us! (There is a Zulip invite in the [Glistix compiler's repository](https://github.com/glistix/glistix)).

## Testing

You can run the integration tests and check out generation results by:

1. Installing `glistix`, e.g. by running `nix develop`
2. Running `cd integration/default-config`
3. Executing `./test.sh`
4. Generation results should appear in the `result` folder.

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
nix develop   # Optional: Spawn a shell with glistix if you don't have it
cd integration/default-config && ./test.sh # Run generation test
```

## License

Licensed under MIT or Apache-2.0, at your option.
