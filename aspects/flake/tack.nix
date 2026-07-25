{ config, lib, ... }:
{
  options.tack = lib.mkOption {
    type = lib.types.submodule {
      freeformType = lib.types.toml;
    };
  };

  config = {
    tack = {
      tack.url = "gh:manic-systems/tack";

      shorturls = {
        gh = "github:{path}";
        path = "git+file:///{path}";
        nixpkgs = "github:NixOS/nixpkgs/nixpkgs-{path}";
        applefont = "https://devimages-cdn.apple.com/design/resources/download/{path}.dmg";
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
        inputs,
        pkgs,
        ...
      }:
      {
        apps.write-tack = {
          type = "app";
          meta.description = "A flake-file like tack pins.toml updater";
          program =
            lib.getExe
            <| pkgs.writeShellApplication {
              name = "write-tack";
              runtimeInputs = [ pkgs.delta ];
              text =
                let
                  tomlFormat = pkgs.formats.toml { };
                  cfg = config.tack;

                  tackInputs = lib.removeAttrs cfg [
                    "all_follow"
                    "shorturls"
                  ];

                  tackToml =
                    ((cfg |> lib.filterAttrs (n: _: n == "all_follow" || n == "shorturls")) // { inputs = tackInputs; })
                    |> tomlFormat.generate "pins.toml";

                  prevInputs = inputs |> lib.attrNames;
                  finalInputs = tackInputs |> lib.attrNames;

                  newInputs = finalInputs |> lib.subtractLists prevInputs |> lib.join " ";
                in
                /* bash */ ''
                  LOCK_FILE="''${1:-./.tack/pins.toml}"

                  if [[ ! -f "$LOCK_FILE" ]]; then
                    echo "Error: file not found: $LOCK_FILE" >&2
                    exit 1
                  fi

                  delta --dark --diff-highlight "$LOCK_FILE" ${tackToml} || true
                  install -m644 -DT ${tackToml} "$LOCK_FILE"
                  ${lib.optionalString (newInputs != "") "tack update ${newInputs}"}
                  if [[ $# -gt 0 ]]; then
                    nh os "$@"
                  fi
                '';
            };
        };
      };

    exo.core =
      {
        constants,
        packages',
        pkgs,
        ...
      }:
      {
        hj.packages = [
          (packages'.tack.overrideAttrs (
            finalAttrs: previousAttrs: {
              doCheck = false;
              patches = (previousAttrs.patches or [ ]) ++ [
                (pkgs.fetchpatch2 {
                  name = "add --exclude argument";
                  url = "https://github.com/manic-systems/tack/pull/86.patch";
                  hash = "sha256-WbwxtkG9P1fMgnqU42s/NqGnUXKFbOg/KNJXJvo/1YE=";
                })
              ];
            }
          ))
        ];

        programs.fish.shellAliases.tack-write = "cd ${constants.cfgdir} && nix run .#tack-write";

        hj.environment.sessionVariables.TACK_NIX_CONF_TOKENS = 1;
      };
  };
}
