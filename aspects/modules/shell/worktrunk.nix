{
  exo.core = {
    my.worktrunk = {
      enable = true;
      settings = {
        merge = {
          squash = false;
          commit = false;
          rebase = true;
          remove = false;
          verify = true;
          ff = true;
        };
        skip-shell-integration-prompt = true;
        skip-commit-generation-prompt = true;
      };
    };
  };

  exo.skeleton =
    {
      wrapPackage,
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.worktrunk;
      toml = pkgs.formats.toml { };
    in
    {
      options.my.worktrunk = {
        enable = lib.mkEnableOption { };

        settings = lib.mkOption {
          inherit (toml) type;
          default = { };
          description = "Options to go into worktrunk's toml config";
        };

        moreCfg = lib.mkOption {
          type = with lib.types; nullOr (either path lines);
          default = "";
          description = "Additional config lines.";
        };

        package = lib.mkOption {
          default = wrapPackage (
            { wlib, ... }:
            {
              package = pkgs.worktrunk;
              env.WORKTRUNK_CONFIG_PATH = wlib.files;
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
        programs.fish.interactiveShellInit = "${lib.getExe cfg.package} config shell init fish | source";
      };

      _file = ./worktrunk.nix;
    };
}
