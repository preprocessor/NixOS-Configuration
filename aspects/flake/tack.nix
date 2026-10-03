{
  rootPath,
  config,
  lib,
  ...
}:
{
  options.tack = {
    shorturls = lib.mkOption {
      type = lib.types.nullOr (lib.types.attrsOf lib.types.str);
    };

    all_follow = lib.mkOption {
      type = lib.types.nullOr (lib.types.attrsOf lib.types.str);
    };

    omit_inputs.names = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = [ ];
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
              description = ''
                Tag pins with a group to print them under headers in tack look and tack update, or group 
              '';
            };

            group = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              description = ''
                Tag pins with a group to print them under headers in tack look and tack update.
              '';
            };

            frozen = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              description = ''
                A frozen pin stays at its locked rev through tack update, and only moves when named directly.
              '';
            };

            patches = lib.mkOption {
              type = lib.types.nullOr (lib.types.listOf lib.types.str);
            };

            submodules = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              description = ''
                Recursively fetch git submodules, disabled by default.
              '';
            };

            follows = lib.mkOption {
              type = lib.types.nullOr (lib.types.attrsOf lib.types.str);
            };

            exclude_follow = lib.mkOption {
              type = lib.types.nullOr (lib.types.listOf lib.types.str);
            };
          };
        }
      );
    };
  };

  config = {
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
                pkgs.nh
              ];

              text =
                let
                  cfg = config.tack;

                  joinMapAttrs = lib.concatMapAttrsStringSep;
                  toTomlStr = s: ''"${s}"'';
                  toTomlAttrs = attr: "{ ${joinMapAttrs ", " (name: value: ''${name} = "${value}"'') attr} }";
                  toTomlList = list: "[${list |> map toTomlStr |> lib.join ", "}]";

                  fromAttrValue =
                    value:
                    (
                      if lib.isAttrs value then
                        toTomlAttrs
                      else if lib.isList value then
                        toTomlList
                      else if lib.isString value then
                        toTomlStr
                      else
                        toString
                    )
                      value;

                  mapAttrValuesToToml = joinMapAttrs "\n" (n: v: "${n} = ${v |> fromAttrValue}");

                  tackOptsToml =
                    cfg
                    |> lib.flip lib.removeAttrs [ "inputs" ]
                    |> joinMapAttrs "\n" (
                      name: value: ''
                        [${name}]
                        ${value |> mapAttrValuesToToml}
                      ''
                    );

                  tackInputsToml =
                    cfg.inputs
                    |> joinMapAttrs "\n" (
                      name: value: ''
                        [inputs.${name}]
                        ${value |> lib.filterAttrs (_: value: !isNull value) |> mapAttrValuesToToml}
                      ''
                    );

                  tackTomlString =
                    ''
                      ${tackOptsToml}
                      ${tackInputsToml}
                    ''
                    |> lib.trim;

                  # Get the content of pins.toml as a string
                  oldTackTomlString = lib.readFile (rootPath + /.tack/pins.toml);

                  # Parse pins.toml for the inputs section
                  oldInputs = (lib.fromTOML oldTackTomlString).inputs;
                  newInputs = cfg.inputs;

                  oldKeys = lib.attrNames oldInputs;
                  newKeys = lib.attrNames newInputs;
                  # Inputs that exist in new but not in old
                  newInputNames = newKeys |> lib.subtractLists oldKeys;
                  # Inputs that exist in both but have different URLs
                  changedInputNames =
                    (lib.intersectLists oldKeys newKeys)
                    |> lib.filter (name: oldInputs.${name}.url != newInputs.${name}.url);

                  # Merge the new and changed inputs into a single list
                  updatedInputs = (newInputNames ++ changedInputNames);
                  # Find removed inputs
                  removedInputs = oldKeys |> lib.subtractLists newKeys;
                in
                /* bash */ ''
                  PINS_FILE="./.tack/pins.toml"
                  TMP_PINS="/tmp/old_pins.toml"

                  if [[ ! -f "$PINS_FILE" ]]; then
                    echo "Error: file not found: $PINS_FILE" >&2
                    exit 1
                  fi

                  ${removedInputs |> map (remKey: "tack rm ${remKey}") |> lib.concatLines}
                  ${lib.optionalString (tackTomlString != oldTackTomlString) /* bash */ ''
                    mv "$PINS_FILE" "$TMP_PINS"
                    cat << EOF > "$PINS_FILE"
                    ${tackTomlString}
                    EOF
                    delta --dark --diff-highlight "$TMP_PINS" "$PINS_FILE" || true
                  ''}
                  ${lib.optionalString (updatedInputs != [ ]) "tack update ${lib.join " " updatedInputs}"}

                  if [[ $# -gt 0 ]]; then
                    nh os "$@"
                  fi
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
