{ config, lib, ... }:
{
  options.tack = lib.mkOption {
    type = lib.types.submodule {
      freeformType = lib.types.toml;
    };
  };

  config = {
    perSystem =
      { pkgs, ... }:
      {
        apps.write-tack = {
          type = "app";
          meta.description = "Update .tack/pins.toml";
          program =
            lib.getExe
            <| pkgs.writeShellApplication {
              name = "write-tack";
              runtimeInputs = [ pkgs.delta ];
              text =
                let
                  cfg = config.tack;
                  tomlFormat = pkgs.formats.toml { };
                  tackToml =
                    (
                      (cfg |> lib.filterAttrs (n: _: n == "all_follow" || n == "shorturls"))
                      // {
                        inputs = lib.removeAttrs cfg [
                          "all_follow"
                          "shorturls"
                        ];
                      }
                    )
                    |> tomlFormat.generate "pins.toml";
                in
                /* bash */ ''
                  delta --dark --diff-highlight .tack/pins.toml ${tackToml} || true
                  install -m444 -DT ${tackToml} .tack/pins.toml
                '';
            };
        };
      };

    tack = {
      tack.url = "gh:manic-systems/tack";

      shorturls = {
        gh = "github:{path}";
        path = "git+file:///{path}";
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

    exo.core =
      { packages', ... }:
      {
        hj.packages = [ packages'.tack ];

        hj.environment.sessionVariables = {
          TACK_NIX_CONF_TOKENS = 1;
        };
      };
  };
}
