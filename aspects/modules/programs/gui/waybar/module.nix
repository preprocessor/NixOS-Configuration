{
  exo.skeleton =
    {
      config,
      pkgs,
      wrapPackage,
      lib,
      ...
    }:
    let
      cfg = config.my.waybar;
      json = pkgs.formats.json { };
    in
    {
      config = lib.mkIf cfg.enable {
        hj.packages = [ cfg.package ];

        hj.systemd.services.waybar = {
          description = "waybar";
          enableDefaultPath = false;
          after = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];
          serviceConfig = {
            ExecStart = lib.getExe cfg.package;
            Restart = "on-failure";
          };
        };
      };

      options.my.waybar = {
        enable = lib.mkEnableOption { };

        config = lib.mkOption {
          inherit (json) type;
          default = { };
          description = "Options to go into waybar's config.json";
        };

        style = lib.mkOption {
          type = with lib.types; nullOr (either str lines);
          default = "";
          description = "Content of waybar's style.css";
        };

        package = lib.mkOption {
          default = wrapPackage (
            { files, wlib, ... }:
            {
              package = pkgs.waybar;
              args = [
                "--config ${files.config}"
                "--style ${files.style}"
              ];
              files = {
                config = {
                  relPath = "config/config.jsonc";
                  file = wlib.json "config.jsonc" cfg.config;
                };
                style = {
                  relPath = "config/style.css";
                  file = cfg.style;
                };
              };
            }
          );
        };
      };
    };

}
