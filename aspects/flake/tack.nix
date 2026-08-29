{
  rootPath,
  config,
  lib,
  ...
}:
{
  # Create a top-level option for tack, to be used like flake-file
  options.tack = {
    shorturls = lib.mkOption {
      type = with lib.types; nullOr (attrsOf str);
    };

    all_follow = lib.mkOption {
      type = with lib.types; nullOr (attrsOf str);
    };

    inputs = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            url = lib.mkOption { type = lib.types.str; };

            type = lib.mkOption {
              type = lib.types.nullOr (
                lib.types.enum [
                  "fetch"
                  "fixed"
                ]
              );
            };

            follows = lib.mkOption {
              type = with lib.types; nullOr (attrsOf str);
            };

            exclude_follow = lib.mkOption {
              type = with lib.types; nullOr (listOf str);
            };
          };
        }
      );
    };
  };

  config = {
    debug = true;
    # Define a base pins.toml with an input for tack
    tack = {
      inputs.tack.url = "gh:manic-systems/tack";
      shorturls = {
        gh = "github:{path}";
        # local = "git+file://{path}";
        nixpkgs = "github:NixOS/nixpkgs/nixpkgs-{path}";
      };
      all_follow = {
        nixpkgs = "nixpkgs";
        systems = "systems";
        flake-compat = "flake-compat";
        flake-utils = "flake-utils";
        rust-overlay = "rust-overlay";
        treefmt-nix = "treefmt-nix";
      };
    };

    perSystem =
      {
        packages',
        pkgs,
        ...
      }:
      {
        apps.write-tack = {
          type = "app";
          meta.description = "A flake-file like tack pins.toml updater";
          program = lib.getExe (
            pkgs.writeShellApplication {
              name = "write-tack";

              derivationArgs = {
                allowSubstitutes = false;
                preferLocalBuild = true;
              };

              runtimeInputs = [
                packages'.tack
                pkgs.delta
                pkgs.nh
              ];

              text =
                let
                  cfg = {
                    inherit (config.tack) all_follow shorturls;
                    inputs = config.tack.inputs |> lib.filterAttrsRecursive (k: v: v != null);
                  };

                  tomlFormat = pkgs.formats.toml { };
                  tackToml = cfg |> tomlFormat.generate "pins.toml";

                  findChangedInputs =
                    old: new:
                    let
                      oldKeys = lib.attrNames old;
                      newKeys = lib.attrNames new;
                      # Inputs that exist in new but not in old
                      newInputNames = newKeys |> lib.subtractLists oldKeys;
                      # Inputs that exist in both but have different URLs
                      changedInputNames =
                        (lib.intersectLists oldKeys newKeys) |> lib.filter (name: old.${name}.url != new.${name}.url);

                      # Merge the new and changed inputs into a single list
                      newInputs = (newInputNames ++ changedInputNames);
                      # Find removed inputs
                      removedInputs = oldKeys |> lib.subtractLists newKeys;
                    in
                    {
                      hasUpdates = newInputs != [ ];
                      hasRemovals = removedInputs != [ ];
                      removals = removedInputs |> map (remKey: "tack rm ${remKey}") |> lib.concatLines;
                      updates = "tack update ${newInputs |> lib.join " "}";
                    };
                  # Get the content of pins.toml as an attrset
                  oldTackInputs = lib.importTOML (rootPath + /.tack/pins.toml);
                  changedInputs = findChangedInputs oldTackInputs.inputs cfg.inputs;
                in
                /* bash */ ''
                  LOCK_FILE="./.tack/pins.toml"

                  if [[ ! -f "$LOCK_FILE" ]]; then
                    echo "Error: file not found: $LOCK_FILE" >&2
                    exit 1
                  fi

                  ${lib.optionalString changedInputs.hasRemovals changedInputs.removals}
                  ${lib.optionalString (changedInputs.hasRemovals || changedInputs.hasUpdates) /* bash */ ''
                    delta --dark --diff-highlight "$LOCK_FILE" ${tackToml} || true
                    install -m644 -DT ${tackToml} "$LOCK_FILE"
                  ''}
                  ${lib.optionalString changedInputs.hasUpdates changedInputs.updates}

                  if [[ $# -gt 0 ]]; then
                    nh os "$@"
                  fi
                '';
            }
          );
        };
      };

    exo.core =
      {
        constants,
        packages',
        ...
      }:
      {
        hj.packages = [ packages'.tack ];

        programs.fish.shellAliases.tack-write = "cd ${constants.cfgdir} && nix run .#tack-write";

        hj.environment.sessionVariables.TACK_NIX_CONF_TOKENS = 1;
      };
  };
}
