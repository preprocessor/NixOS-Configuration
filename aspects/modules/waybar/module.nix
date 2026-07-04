{
  w.default =
    {
      birdee,
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.custom.programs.waybar;
      json = pkgs.formats.json { };
    in
    {
      config = lib.mkIf cfg.enable {
        hj.packages = [ cfg.package ];

        custom.programs.hyprland.startup = [ ''hl.exec_cmd("${lib.getExe cfg.package}")'' ];

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

      options.custom.programs.waybar = {
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
          default = birdee.lib.wrapPackage (
            { config, ... }:
            {
              inherit pkgs;
              package = pkgs.waybar;
              flags = {
                "--config" = config.constructFiles.config.path;
                "--style" = config.constructFiles.style.path;
              };
              constructFiles = {
                config = {
                  relPath = "config.jsonc";
                  builder = ''install -m655 -DT "${json.generate "config.jsonc" cfg.config}" "$2"'';
                };
                style = {
                  relPath = "style.css";
                  content = cfg.style;
                };
              };
            }
          );
        };
      };
    };

}
