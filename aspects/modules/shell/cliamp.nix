{
  w.default =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        cliamp
        yt-dlp
      ];

      custom.programs.hyprland.lua.files."window_rules.cliamp".content = /* lua */ ''
        hl.window_rule({
          name = "float cliamp",
          match = {
            class = "^CliampMusic$"
          },
          float = true,
          center = true,
          size = { 1000, 1000 }
        })
      '';

      custom.programs.otter-launcher.modules = [
        {
          cmd = ''hyprctl dispatch hl.dsp.exec_sh("kitty --app-id=CliampMusic -e ${pkgs.cliamp}/bin/cliamp; exit")'';
          description = "amp";
          prefix = "cli";
        }
      ];
    };
}
