{
  exo.mods.desktop =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        satty
        grim
      ];

      my.hyprland = {
        lua.files."keybinds.hyprpicker".content = /* lua */ ''
          hl.bind("Print", hl.dsp.exec_cmd('grim - | satty -f - --copy-command wl-copy --fullscreen -o "~/Pictures/Screenshots/%Y-%m-%d %H:%M:%S.png"'))
        '';

        windowrules.general = [
          {
            match.class = "^com.gabm.satty$";
            rules = {
              float = true;
              no_anim = true;
              fullscreen = true;
            };
          }
        ];
      };
    };
}
