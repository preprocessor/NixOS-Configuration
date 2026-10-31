# My NixOS Config

This is my personal NixOS setup, and it's kind of grown into its own little flake
framework. Instead of pulling in flake-parts, flake-file, wrapper-modules, stylix, base16.nix,
and a pile of other helpers, it reimplements the pieces I actually use with `lib` and `nixpkgs`.

I did this because:
1. To learn more about NixOS and the Nix expression language.
2. To have exactly the features I desire and nothing more.
3. To make each abstraction (*hopefully*) small enough to read in one sitting.

## Design Philosophy
### Nixpkgs is the only dependency

The interesting machinery is built from `lib` and `nixpkgs` — no
flake-parts, no flake-utils, no stylix, no base16.nix. Fewer moving parts means fewer
inputs to pin, fewer upgrade cliffs, and fewer uncontrolled abstractions.

### Every abstraction is small enough to audit

The `perSystem` layer is a couple hundred lines. `mkScheme` is ~100. The
package wrapper is one `runCommand`. Each one replaces a third-party tool with a
deliberately narrow reimplementation, so understanding the repo doesn't require
understanding a framework first.

### Everything is a module

`evalModules` isn't just for lib.nixosSystem here. The flake top level, every `perSystem`
fragment, every wrapped package, and each host config are all evaluated as modules
with typed options. The schemas document themselves, and composition happens through
deferred modules instead of hand-rolled merging.

### Pins are data, not flake inputs

Tack replaces `inputs` with a declarative, signed, patchable `pins.toml`. My own
`tack.nix` exposes that file as top-level nix options and generates it, ala flake-file.
Dependencies show up in a reviewable diff instead of hiding in a `flake.lock`.

### Compose hosts from modules, not one giant config

A host just declares its user, state version, colorscheme, hardware profile, and which
modules it wants. Modules organize themselves into `core`, `skeleton`, `host`, `hardware`, or
a named module, and `configurations.nix` assembles the final `nixosSystem`. Adding
a capability is opt-in, and adding a host is about a dozen lines.

## Areas of interest

If you're here to steal ideas, these are worth reading:

| # | Area | What it is |
|---|------|------------|
| 1 | [A hand-rolled `perSystem`](#a-hand-rolled-persystem) | flake-parts' per-system abstraction, rebuilt from scratch |
| 2 | [Tack inputs, not flake inputs](#tack-not-flake-inputs) | a flake-file-style interface that generates `pins.toml` |
| 3 | [The package wrapper](#the-package-wrapper) | an option-driven `wrapPackage` on top of `makeWrapper` |
| 4 | [Lib-only colorschemes](#lib-only-colorschemes) | a base16/24 engine with zero nixpkgs imports |
| 5 | [Composable host configurations](#composable-host-configurations) | bucket-based module composition for hosts |

## A hand-rolled perSystem

> file: [`flake.nix`](./flake.nix)

This is the part that replaces flake-parts. It runs two `evalModules` passes: the first
evaluates the top-level `./aspects` tree (flake-level options, tack pins, schemes), and
the second re-runs one `perSystem` module once per system with extra arguments.

The glue is a handful of small helpers:

- `projectInput` narrows a flake-shaped input to a single system, dropping the system
  layer so `inputs'.foo.packages.bar` means `inputs.foo.packages.${system}.bar`.
- `withSystem` builds the per-system argument bundle: `pkgs`, `inputs'`, `self'`,
  `packages'`, `meta`, `system`, `rootPath`.
- `packages'` is a convenience layer that picks `packages.default`, falls back to a
  package named after the input, then merges everything into one set.
- output transposition flips `system -> category -> derivation` into the
  `category -> system -> derivation` shape flake outputs expect.

The result is a flake that still looks normal from the outside (`packages.x86_64-linux.*`,
`nixosConfigurations.*`) but gives every module the same ergonomic arguments
flake-parts users get.

## Composable host configurations

> file: [`aspects/hosts/configurations.nix`](./aspects/hosts/configurations.nix)

Hosts are declared as submodules, so `exo.configurations.ramiel` only accepts the fields
it should: `system`, `stateVersion`, `user`, `hardware`, `scheme`, `modules`, and
`extraConfig`. From each entry, the module builds a `nixosSystem` with the right
`specialArgs` (`scheme`, `pkgs`, `inputs'`, `hostname`, `constants`, ..).

The composition is the good part. Modules contribute deferred modules to buckets:

- `exo.core` — stuff every host needs
- `exo.skeleton` — the shared base
- `exo.hardware.<profile>` — hardware-specific bits
- `exo.mods.<name>` — opt-in feature sets like `desktop`, `gaming`, `comms`
- `exo.host.<hostname>` — one-off host tweaks

A host just lists the modules it wants, and the final module list is assembled from those
buckets. So enabling gaming on a second machine is one word, not a copy-paste of config.

## [Tack](https://github.com/manic-systems/tack), not flake inputs

> file: [`aspects/flake/tack.nix`](./aspects/flake/tack.nix)

Dependencies live in `.tack/pins.toml` and get imported straight into the flake, so
there's no `flake.lock` and no `inputs` block to hand-edit. This module gives that file
a typed option schema (`tack.inputs.*`, `tack.shorturls`, `tack.signers`, `all_follow`,
patches, follows, and so on) and then writes it back out with `write-tack`.

`write-tack`: a shell app that turns the evaluated options into TOML with a custom generator,
diffs them against the current file, and only runs `tack update` or `tack patch` for
inputs that actually changed. It also rewrites the file so every input starts with its
`url`, which makes the diffs much nicer to read. Think of it as flake-file, except the
output is a tack `pins.toml` file.

## Package wrappers

> file: [`./aspects/flake/wrappers.nix`](./aspects/flake/wrappers.nix)

`wrapPackage` is a module-based wrapper around `makeWrapper`. Instead of assembling
`--set` and `--prefix` flags by hand, you describe what you want and let the options do
the work:

```nix
wrapPackage {
  package = pkgs.kitty;
  binName = "kitty";
  env.KITTY_CONFIG_DIRECTORY = files.config.dir;
  files.config = {
    path = "config/kitty.conf";
    file =
    let
    toKittyConfig = lib.concatMapAttrsStringSep "\n" (
      name: value:
      let
        mkValue = v: v |> (if lib.isBool v then lib.boolToYesNo else toString);
      in
      if lib.isList value then
        value |> lib.concatMapStringsSep "\n" (v: "${name} ${mkValue v}")
      else
        "${name} ${mkValue value}"
    );
    in
    ''
    # Settings
    ${toKittyConfig cfg.settings}

    # Keybindings
    ${toKittyConfig cfg.keybindings}

    # Theme
    ${cfg.theme}
    '';
  runtimePackages = [ pkgs.ydotool ];
  aliases = [ "term" ];
}
```

It supports `env`, `args`, `runCommand`, `runtimePackages`, `linkedPackages`, `files`,
and `aliases`. Files passed as strings go through `passAsFile`, store paths get
symlinked, and `wlib` gives you placeholder-aware helpers for generating JSON, TOML,
YAML, or INI inside the wrapper.

## Colorschemes

> file: [`aspects/flake/16.nix`](./aspects/flake/16.nix)

This is a stripped-down base16.nix with no dependency on nixpkgs. Give it a scheme and
`mkScheme` normalizes it to base24, adds mnemonic names (`red`, `bright-blue`, ..), and
exposes a few useful forms:

- `scheme.base0D` — the raw hex value
- `scheme.noHashtag.base0D` — hex without the `#`
- `scheme.asRgb8.base0D` — `{ r, g, b; }` in 0–255
- `scheme.asRgb.base0D` — the same, normalized to 0–1

The schemes themselves live in [`schemes.nix`](./aspects/flake/schemes.nix), and hosts
pick one by name. No external theming framework, just a bit of hex math in `lib`.

## Honerable mentions

A few smaller modules round things out:

- [`schemes.nix`](./aspects/flake/schemes.nix) — the actual base24 palettes.
- [`sops.nix`](./aspects/flake/sops.nix) — sops-nix wiring with age keys and secrets.
- [`remote-build.nix`](./aspects/flake/remote-build.nix) — remote package builds plus the
  Cachix substituters, with a `list-remote-packages` app for CI.
- [`utils.nix`](./aspects/flake/utils.nix) — a shared `utils` option passed through to
  the skeleton, used mainly to share functions across multiple modules/files.

## Repository layout

```text
.
├── flake.nix                  # the perSystem / output machinery
├── aspects/
│   ├── flake/                 # flake-level modules (tack, wrappers, 16, sops, ..)
│   ├── hosts/
│   │   ├── configurations.nix # host schema and nixosSystem assembly
│   │   └── ramiel/            # one host: boot, hardware, packages
│   └── modules/
│       ├── core/              # base system modules
│       ├── extra/             # gaming, rice, xdg
│       ├── programs/          # gui and tui apps
│       └── services/          # audio, networking, disks, ..
├── .tack/                     # pins.toml and patches
└── justfile
```
That's the tour. If you're building something similar, the five areas above are the
ones I'd start with — they're the parts that made the rest of the config pleasant to
live in.
