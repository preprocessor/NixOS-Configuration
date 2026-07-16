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

        my.hyprland.startup = [ ''hl.exec_cmd("${lib.getExe cfg.package}")'' ];

        # systemd.user.services.waybar = {
        #   description = "waybar";
        #   after = [ "graphical-session.target" ];
        #   partOf = [ "graphical-session.target" ];
        #   wantedBy = [ "graphical-session.target" ];
        #   serviceConfig = {
        #     ExecStart = lib.getExe cfg.package;
        #     Restart = "on-failure";
        #   };
        # };
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
            { wlib, ... }:
            {
              package = pkgs.waybar;
              args = [
                "--config ${wlib.files}/config.jsonc"
                "--style ${wlib.files}/style.css"
              ];
              files = {
                "config.jsonc" = json.generate "config.jsonc" cfg.config;
                "style.css" = cfg.style;
              };
            }
          );
        };
      };
    };

}
