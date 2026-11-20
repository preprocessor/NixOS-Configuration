# My NixOS Configuration

> A modular multi-host NixOS configuration.

This is my personal NixOS setup, and it's kind of grown into its own flake framework.
I enjoyed many of the features of popular modules like flake-parts, flake-file, and nix-wrapper-modules,
but with each of them I found incompatibilities with my personal workflow.
So instead, my flake reimplements the pieces I actually use to meet my needs and preferences.

## Features

- A minimal [flake-parts](https://github.com/hercules-ci/flake-parts) perSystem implementation
- Tack as an input pinner, instead of flake inputs and `flake.lock`
- A [flake-file](https://github.com/denful/flake-file)-like interface to tack
- A module-based package wrapper
- Custom colorschemes available through a global `scheme` object
- Composable, module based host configurations
- [hjem](https://github.com/feel-co/hjem) instead of home-manager
- remote package builds with github actions

> [!WARNING]
> These configurations won't work on your machines due to
> lack of secrets and hardware differences
>
> The exposed packages should work though,
> and I hope my modules can be educational to others

## Minimal flake-parts perSystem implementation

> file: [`flake.nix`](./flake.nix)

Here we implement flake-parts' perSystem. It runs two `evalModules` passes: the first
evaluates the top-level `./aspects` tree (flake-level options, tack pins, schemes), and
the second re-runs one `perSystem` module once per system with extra arguments.

It's implemented with a handful of small helpers:

- `systemInput` narrows a flake-shaped input to a single system, dropping the system
  layer so `inputs'.foo.packages.bar` means `inputs.foo.packages.${system}.bar`.
- `withSystem` builds the per-system argument bundle.
- output transposition flips `system -> category -> derivation` into the
  `category -> system -> derivation` shape flake outputs expect.

The result is a flake that still looks normal from the outside (`packages.x86_64-linux.*`,
`nixosConfigurations.*`) but gives every module the same ergonomic arguments
flake-parts users get.

## Tack module + flake app + fish completions

> file: [`tack.nix`](./aspects/flakeModules/tack.nix)

Tack is declaratively configured and managed using the top-level `tack` option.
This option mirrors the layout of pins.toml for ease of use and compatibility.

```nix
{
  tack.inputs.hjem = {
    url = "gh:feel-co/hjem";
    group = "nix";
  };
}
```
```sh
nix run .#write-tack
```

`write-tack` is a Nix flake app that:
1. Takes `config.tack` and generates `pins.toml` from it using a custom toml generator.
2. Diffs them against the current file
3. Only runs `tack update` or `tack patch` for new or changed inputs

The custom generator:
    - renders the tack options first and tack.inputs last
    - renders the url of each input first and the other elements after
    - keeps nested attribute sets within their parent input (`input.*.follows.* = "*"`)

```toml
# .tack/pins.toml
[inputs.hjem]
url = "gh:feel-co/hjem"
group = "nix"
```

Finally, `self'.packages.tack-fish-completions` takes tack's inputs and groups and uses them to generate fish
completions for tack subcommands that take an input or group name as an argument,
such as `tack update` or `tack materialize`

## Module based package wrapper
> file: [`wrapper.nix`](./aspects/flakeModules/wrapper.nix)

`wrapPackage` is a function that takes a module as an argument and returns a wrapped package derivation.
The following options are available to be used in the module to define a package.

| Option | Type | Default | Description |
|---|---|---|---|
| `package` | `package` | none (required) | The package to wrap. |
| `linkedPackages` | `listOf package` | `[ ]` | Extra packages symlinked into the derivation root. Unlike `runtimePackages`, these don't inherit environment variables passed to the wrapper. |
| `binName` | `str` | `config.package.meta.mainProgram or (lib.getName config.package)` | Name of the wrapped binary at `$out/bin/<binName>`. |
| `args` | `listOf str` | `[ ]` | Arguments to pass to the binary. |
| `runCommand` | `listOf str` | `[ ]` | Commands to run before the executable. |
| `env` | `attrsOf (oneOf [ str number bool path ])` | `{ }` | Environment variables to pass to the binary. |
| `runtimePackages` | `listOf package` | `[ ]` | Packages to add to `PATH` at runtime. |
| `files` | `attrsOf (submodule)` | `{ }` | Files or directories to add to the output. Strings go through `passAsFile`, store paths are linked directly. |
| `files.<name>.path` | `str` | none (required) | Path relative to the root of the output. |
| `files.<name>.file` | `either str pathInStore` | none (required) | String or path to add to the output. |
| `aliases` | `listOf str` | `[ ]` | Aliases to the main binary. |
| `wrapper` | `package` (read-only) | none | The built, wrapped derivation. |

```nix
wrapPackage (
  { files, wlib, ... }:
  {
    package = self'.packages.eza;
    env.EZA_CONFIG_DIR = files.theme.dir;
    files.theme = {
      path = "config/theme.yml";
      file = wlib.yaml "theme.yml" cfg.settings;
    };
  }
)
```
`files` and `wlib` are module arguments accessible from within the `wrapPackage` modules.

### Files

The `files` argument is a way to reference paths of files generated inside the wrapper.
In the above example we create `files.theme` with its path set to `"config/theme.yml"`, we also use the files argument to set `EZA_CONFIG_DIR` to `files.theme.dir`.

- `files.<name>.dir` gives the path of the file's parent directory.
- `files.<name>` gives the path of the actual file.
- `files.<name>.name` gives the name (basename) of the file.

### Wlib
Provides a unified interface for generating configuration format libraries, including JSON, TOML, YAML, and INI, using Nix's pkgs.formats.
It also provides `wlib.out` which returns the wrapper's output path.

## Colorschemes
> file: [`colors.nix`](./aspects/flakeModules/colors.nix)

This is a stripped-down base16.nix.
Give it a scheme attribute and the `mkScheme` function normalizes it to base24, adds mnemonic names (`red`, `bright-blue`, ..), and exposes a few useful forms:

- `scheme.base0D` — the raw hex value
- `scheme.noHashtag.base0D` — hex without the `#`
- `scheme.asRgb8.base0D` — `{ r, g, b; }` in 0–255
- `scheme.asRgb.base0D` — the same, normalized to 0–1

The color schemes themselves are defined in [`schemes.nix`](./aspects/flakeModules/schemes.nix), and hosts pick one by name. This is passed to the mkScheme function and provided to the host as the `scheme` specialArg.

## Composable host configurations

> file: [`configurations.nix`](./aspects/nixosConfigurations/configurations.nix)

Modules are organized under the top-level `modules` set and split into the following categories:

- `modules.core` — common configuration modules provided to every host
- `modules.hardware.<profile>` — hardware-specific modules
- `modules.host.<hostname>` — per host modules
- `modules.features.<name>` — opt-in feature sets like `bluetooth`, `gaming`, `comms`

A host just lists the modules it wants and the hardware it uses, then the final module list is assembled from those sets.
So enabling a feature on a configuration is one word, not a copy-paste of config.

> file: [`ramiel.nix`](./aspects/nixosConfigurations/ramiel/ramiel.nix)
```nix
{ config, ... }:
{
  modules.configurations.ramiel = {
    user = "wyspr";
    stateVersion = "25.11";
    scheme = "amber";
    hardware = "desktop-pc";
    modules = with config.modules.features; [
      bluetooth
      printing
      desktop
      gaming
      neovim
      comms
      rocm
    ];
  };
}
```
This will receive the following modules:
```
modules.core
modules.hardware.desktop-pc
modules.host.ramiel
modules.features.bluetooth
modules.features.printing
modules.features.desktop
modules.features.gaming
modules.features.neovim
modules.features.comms
modules.features.rocm
```

## Repository layout

```text
.
├── flake.nix                  # the perSystem / output machinery
├── aspects/
│   ├── flakeModules/          # flake-level modules (tack, wrappers, 16, sops, ..)
│   ├── hjemModules/           # hjem (user) level modules (kitty, hyprland, yazi, ...)
│   ├── nixosConfigurations/
│   │   ├── configurations.nix # host schema and custom module system
│   │   ├── ramiel/            # my desktop pc
│   │   └── xyz/               # a vps that hosts my package cache and personal git server
│   ├── packages/              # package overrides/wrappers
│   └── features/              # where modules.features are defined
└── .tack/                     # pins.toml and patches
```
