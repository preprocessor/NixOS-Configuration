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
              text =
                let
                  cfg = config.tack;
                  toml = pkgs.formats.toml { };
                  tackToml = (cfg |> lib.filterAttrs (n: _: n == "all_follow" || n == "shorturls")) // {
                    inputs = lib.removeAttrs cfg [
                      "all_follow"
                      "shorturls"
                    ];
                  };
                in
                /* bash */ "install -m444 -DT '${toml.generate "pins.toml" tackToml}' .tack/pins.toml";
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

    w.default =
      { packages', ... }:
      {
        hj.packages = [ packages'.tack ];
      };
  };
}
