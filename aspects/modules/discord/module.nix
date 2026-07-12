{
  w.default =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      json = pkgs.formats.json { };
      cfg = config.my.vesktop;
    in
    {
      options.my.vesktop = {
        enable = lib.mkEnableOption { };

        package = lib.mkPackageOption pkgs "vesktop" { };

        settings = lib.mkOption {
          inherit (json) type;
          description = "Vesktop settings";
          default = { };
        };

        vencord.settings = lib.mkOption {
          inherit (json) type;
          default = { };
          description = "Vencord settings";
        };
      };

      config = lib.mkIf cfg.enable {
        hj.packages = [ cfg.package ];

        hj.xdg.config.files = {
          "vesktop/settings.json".source = json.generate "vesktop-settings" cfg.settings;
          "vesktop/settings/settings.json".source = json.generate "vencord-settings" cfg.vencord.settings;
        };
      };
    };
}
