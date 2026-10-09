{
  rootPath,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.tack = {
    shorturls = mkOption {
      type = types.nullOr (types.attrsOf types.str);
      description = ''
        Shorturl schemes. `scheme:rest` expands by substituting `rest` into
        the `{path}` placeholder of the template.
      '';
      example = {
        gh = "github:{path}";
      };
    };

    signers = mkOption {
      type = types.nullOr (types.attrsOf (types.either types.str (types.listOf types.str)));
      description = ''
        Attribute set of public keys of signers you trust.
        The name is the username associated with the key[s]
        The value may be a single key or a list of keys.

        Keys can consist of a SSH public key line, an ASCII-armored PGP public key, or a path under .tack to a file
        holding either.

        See: https://github.com/manic-systems/tack#signers
      '';
      example = {
        alice = "ssh-ed25519 AAAA...";
        bob = [
          "keys/bob.keys"
          "keys/bob.asc"
        ];
      };
    };

    all_follow = mkOption {
      type = types.nullOr (types.attrsOf (types.either types.str (types.listOf types.str)));
      description = ''
        Follow rules applied to every pin that has a matching input. Two value
        shapes are accepted:

        - `alias = "target"`: every input named `alias` follows your top-level `target` pin.
        - `target = [ "alias1" "alias2" ]`: the key is the canonical target, and the
          key plus every array member alias to it.
      '';
      example = {
        nixpkgs = [
          "nixpkgs-stable"
          "nixpkgs-unstable"
        ];
        fenix = "fenix";
      };
    };

    tack = mkOption {
      type = types.nullOr (
        types.submodule {
          options = {
            recomposable = mkOption {
              type = types.nullOr types.bool;
            };
          };
        }
      );
    };

    omit_inputs = mkOption {
      type = types.nullOr (
        types.submodule {
          options = {
            names = mkOption {
              type = types.nullOr (types.listOf types.str);
            };
          };
        }
      );
    };

    inputs = mkOption {
      default = { };
      type = types.attrsOf (
        types.submodule {
          options = {
            url = mkOption {
              type = types.str;
              description = "Input URL. May use one of the configured shorturl schemes.";
              example = "gh:owner/repo";
            };

            type = mkOption {
              type = types.nullOr (
                types.enum [
                  "fetch"
                  "fixed"
                  "flake"
                ]
              );
              description = ''
                Pin type. `flake` (tack's default when unset) evaluates the input's
                flake.nix; `fetch` exposes only the source tree; `fixed` is a
                hash-locked download that `tack update` will refuse to silently relock.
              '';
            };

            unpack = mkOption {
              type = types.nullOr (
                types.enum [
                  "tarball"
                  "file"
                ]
              );
              description = ''
                Only for `type = "fixed"`. Auto-detected from the URL when unset.
              '';
            };

            group = mkOption {
              type = types.nullOr types.str;
              description = ''
                Tag pins with a group to print them under headers in tack look and tack update.
              '';
            };

            frozen = mkOption {
              type = types.nullOr types.bool;
              description = ''
                A frozen pin stays at its locked rev through tack update, and only moves when named directly.
              '';
            };

            patches = mkOption {
              type = types.nullOr (types.listOf types.str);
              description = "Patches to apply to the input, in order, with no import-from-derivation.";
              example = [
                "https://github.com/NixOS/nixpkgs/pull/444444"
                "patches/nixpkgs/local-fix.patch"
              ];
            };

            omit_inputs = mkOption {
              type = types.nullOr (types.listOf types.str);
            };

            keep_inputs = mkOption {
              type = types.nullOr (types.listOf types.str);
            };

            signers = mkOption {
              type = types.nullOr (types.listOf types.str);
              description = ''
                Require a pin's commits to be signed by keys you trust.

                Keys are defined in Nix by `tack.signers` or in TOML by `[signers]`
              '';
              example = [
                "alice"
                "bob"
              ];
            };

            submodules = mkOption {
              type = types.nullOr types.bool;
              description = ''
                Recursively fetch git submodules, disabled by default.
              '';
            };

            follows = mkOption {
              type = types.nullOr (types.attrsOf types.str);
              description = ''
                Point this pin's inputs at your top-level pins instead of their own lock.
                Keys may be prefixed with `flake:` or `tack:` to target only one side
                when an upstream has both a flake input and a tack pin of that name.
              '';
              example = {
                nixpkgs = "nixpkgs";
                "flake:systems" = "systems";
              };
            };

            exclude_follow = mkOption {
              type = types.nullOr (types.listOf types.str);
              description = "Names of `all_follow` rules that should not apply to this pin.";
            };
          };
        }
      );
    };
  };

  config = {
    # Define a base pins.toml with an input for tack
    tack = {
      inputs.tack = {
        url = "gh:manic-systems/tack";
        group = "nix";
      };
      shorturls = {
        gh = "github:{path}";
        # local = "git+file://{path}";
        nixpkgs = "github:NixOS/nixpkgs/nixpkgs-{path}";
      };
      all_follow = {
        nixpkgs = "nixpkgs";
        systems = "systems";
        flake-utils = "flake-utils";
        rust-overlay = "rust-overlay";
      };
      omit_inputs.names = [
        "flake-compat"
        "pre-commit-hooks"
        "treefmt-nix"
      ];
    };

    perSystem =
      {
        packages',
        self',
        pkgs,
        ...
      }:
      {
        remotePackages = { inherit (packages') tack; };

        apps.write-tack = {
          type = "app";
          meta.description = "A flake-file like, pins.toml updater for tack";
          program = lib.getExe (
            pkgs.writeShellApplication {
              name = "write-tack";

              derivationArgs = {
                allowSubstitutes = false;
                preferLocalBuild = true;
              };

              runtimeInputs = [
                self'.packages.tack
                pkgs.delta
              ];

              text =
                let
                  tack = config.tack |> lib.filterAttrsRecursive (_: value: !isNull value); # Toml generator does not like null values
                  nameValuePairToToml = n: v: "${lib.strings.escapeNixIdentifier n} = ${mapValueToTomlRhs v}";
                  mapAttrSetToToml = sep: lib.concatMapAttrsStringSep sep nameValuePairToToml;
                  mapValueToTomlRhs = v: if lib.isAttrs v then "{ ${mapAttrSetToToml ", " v} }" else lib.toJSON v;
                  tackOptsToml = # Tack options section
                    tack
                    |> lib.flip lib.removeAttrs [ "inputs" ]
                    |> lib.concatMapAttrsStringSep "\n" (
                      name: value: ''
                        [${name}]
                        ${value |> mapAttrSetToToml "\n"}
                      ''
                    );
                  tackInputsToml = # Tack inputs section
                    tack.inputs
                    |> lib.concatMapAttrsStringSep "\n" (
                      name: value: ''
                        [inputs.${name}]
                        ${{ inherit (value) url; } // lib.removeAttrs value [ "url" ] |> mapAttrSetToToml "\n"}
                      ''
                    );
                  # The above is as minimal of a pins.toml generator that I can cook up. I did this because I was not a fan
                  # of how pkgs.formats.toml handles nested attributes. This also lets the file be written so that the inputs
                  # are last and the first item of each input is it's url.
                  oldTackToml = lib.importTOML (rootPath + /.tack/pins.toml); # Read the current pins.toml
                  oldInputs = oldTackToml.inputs;
                  newInputs = tack.inputs;
                  oldKeys = lib.attrNames oldInputs;
                  newKeys = lib.attrNames newInputs;
                  # Inputs that exist in new but not in old
                  newInputNames = newKeys |> lib.subtractLists oldKeys;
                  # Input-level options that, if changed, should *not* trigger a `tack update`
                  normalizeInput = lib.flip lib.removeAttrs [
                    "patches" # patches are managed via a separate method below
                    "frozen"
                    "group"
                  ];
                  # Inputs that exist in both but have changed enough to need a `tack update`
                  changedInputNames =
                    lib.intersectLists oldKeys newKeys
                    |> lib.filter (name: normalizeInput oldInputs.${name} != normalizeInput newInputs.${name});

                  prevPatches = name: oldInputs.${name}.patches or [ ];
                  currPatches = name: newInputs.${name}.patches or [ ];
                in
                /* bash */ ''
                  PINS_FILE="''${TACK_DIR:-.tack}/pins.toml"

                  if [[ ! -f "$PINS_FILE" ]]; then
                    echo "Error: file not found: $PINS_FILE" >&2
                    exit 1
                  fi

                  TMP_PINS="$(mktemp old_pins.toml.XXXXX)"
                  # Delete temp file on script exit
                  trap 'rm -f "$TMP_PINS"' EXIT

                  ${
                    newKeys
                    |> lib.concatMap (
                      name:
                      lib.subtractLists (currPatches name) (prevPatches name)
                      |> map (patch: "tack patch rm ${name} ${lib.escapeShellArg patch}")
                    )
                    |> lib.concatLines
                  }

                  ${
                    let
                      updatedPatchInputs =
                        newKeys |> lib.filter (name: lib.subtractLists (prevPatches name) (currPatches name) != [ ]);
                    in
                    lib.optionalString (updatedPatchInputs != [ ])
                      "tack patch update ${updatedPatchInputs |> lib.join " "}"
                  }

                  ${
                    oldKeys
                    |> lib.subtractLists newKeys
                    |> map (removedInput: "tack rm ${removedInput}")
                    |> lib.concatLines
                  }

                  ${lib.optionalString (tack != oldTackToml) /* bash */ ''
                    mv "$PINS_FILE" "$TMP_PINS"
                    cat << 'EOF' > "$PINS_FILE"
                    ${tackOptsToml}
                    ${tackInputsToml}
                    EOF
                  ''}

                  ${
                    let
                      updatedInputs = newInputNames ++ changedInputNames;
                    in
                    lib.optionalString (updatedInputs != [ ]) "tack update ${lib.join " " updatedInputs}"
                  }

                  ${lib.optionalString (tack != oldTackToml) /* bash */ ''
                    delta --dark --paging=never --diff-highlight "$TMP_PINS" "$PINS_FILE" || true
                  ''}
                '';
            }
          );
        };
      };

    exo.core =
      { packages', ... }:
      {
        hj = {
          packages = [ packages'.tack ];
          environment.sessionVariables.TACK_NIX_CONF_TOKENS = 1;
        };
      };
  };
}
