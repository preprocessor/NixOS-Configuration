{
  w.default =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        cliamp
        yt-dlp
      ];

      wrappers.niri.settings.window-rules = [
        {
          matches = [ { app-id = "^CliampMusic$"; } ];

          open-floating = true;

          default-column-width.fixed = 1000;
          default-window-height.fixed = 1000;

          default-floating-position = _: {
            props = {
              x = 2150;
              y = 300;
            };
          };
        }
      ];

      wrappers.otter-launcher.modules = [
        {
          cmd = "niri msg action spawn -- kitty --app-id=CliampMusic -e ${pkgs.cliamp}/bin/cliamp; exit";
          description = "music player";
          prefix = "amp";
        }
      ];
    };
}
