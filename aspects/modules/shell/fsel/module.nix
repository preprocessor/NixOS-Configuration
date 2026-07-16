{ inputs, ... }:
{
  tack.fsel = {
    url = "gh:Mjoyufull/fsel";
    type = "fetch";
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.fsel = pkgs.rustPlatform.buildRustPackage (final: {
        src = inputs.fsel;
        pname = "fsel";
        version = "git";
        cargoLock.lockFile = final.src + "/Cargo.lock";
      });
    };

  exo.skeleton =
    {
      wrapPackage,
      config,
      self',
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.fsel;
      toml = pkgs.formats.toml { };
    in
    {
      options.my.fsel = {
        enable = lib.mkEnableOption { };

        settings = lib.mkOption {
          inherit (toml) type;
          default = { };
          description = "Options to go into fsel's toml config";
        };

        moreCfg = lib.mkOption {
          type = with lib.types; nullOr (either path lines);
          default = "";
          description = "Additional config lines.";
          example = lib.literalExpression "./config.toml";
        };

        package = lib.mkOption {
          default = wrapPackage (
            { wlib, ... }:
            {
              package = self'.packages.fsel;
              args = [ "--config ${wlib.files}/config.toml" ];
              files =
                "config.toml"
                |> wlib.buildAndAppend' {
                  formatter = toml;
                  buildFrom = cfg.settings;
                  appendString = cfg.moreCfg;
                };
            }
          );
        };
      };

      config = lib.mkIf (cfg.enable) {
        hj.packages = [ cfg.package ];
      };

      _file = ./module.nix;
    };
}
