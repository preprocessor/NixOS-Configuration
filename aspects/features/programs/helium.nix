{
  tack.inputs.helium = {
    url = "gh:amaanq/helium-flake";
    group = "general";
  };

  modules.features.desktop =
    {
      packages',
      config,
      lib,
      ...
    }:
    let
      mimeType = [
        "application/x-extension-shtml"
        "application/x-extension-xhtml"
        "application/x-extension-html"
        "application/x-extension-xht"
        "application/x-extension-htm"
        "x-scheme-handler/unknown"
        "x-scheme-handler/https"
        "x-scheme-handler/http"
        "application/xhtml+xml"
        "application/json"
        "application/pdf"
        "text/html"
      ];
    in
    lib.mkMerge [
      {
        hj.packages = [ packages'.helium ];

        hj.environment.sessionVariables.BROWSER = "helium";

        xdg.mime.defaultApplications =
          mimeType |> map (mime: lib.nameValuePair mime [ "helium.desktop" ]) |> lib.listToAttrs;

        my.xdg.desktopEntries."helium" = {
          name = "Helium";
          exec = "helium --new-window %U";
          terminal = false;
          type = "Application";
          icon = "helium";
          inherit mimeType;
        };
      }

      (lib.mkIf config.my.hyprland.enable {
        my.hyprland.startup = [
          /* lua */ ''hl.exec_cmd("${lib.getExe packages'.helium}", { workspace = "1 silent" })''
        ];

        my.hyprland.lua.files."keybinds.helium".content = /* lua */ ''
          hl.bind("SUPER + B", hl.dsp.exec_raw("helium"), { release = true })
        '';
      })
    ];
}
