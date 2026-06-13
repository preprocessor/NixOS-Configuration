{
  w.default =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        cliamp
        yt-dlp
      ];

      wrappers.hyprland.lua.files."window_rules".content = /* lua */ ''
        hl.window_rule({
          name = "float cliamp",
          match = {
            class = "^CliampMusic$"
          },
          float = true,
          center = true,
          size = "1000 1000"
        })
      '';

      wrappers.otter-launcher.modules = [
        {
          cmd = ''hyprctl dispatch exec_sh("kitty --app-id=CliampMusic -e ${pkgs.cliamp}/bin/cliamp; exit")'';
          description = "music player";
          prefix = "amp";
        }
      ];
    };
}
