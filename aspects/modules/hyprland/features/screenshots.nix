{
  exo.mods.desktop =
    { pkgs, lib, ... }:
    {
      my.hyprland = {
        lua.files."layer_rules.general".content = /* lua */ ''
          hl.layer_rule({
            match   = { namespace = "^(wayfreeze)$" },
            no_anim = true,
          })

          hl.layer_rule({
            match     = { namespace = "^(selection)$" },
            animation = "fade"
          })
        '';

        lua.files."keybinds.screenshot".content = /* lua */ ''
          -- Screenshots
          hl.bind("Print", hl.dsp.exec_cmd('wayfreeze & PID=$!; sleep .1; grim -g "$(slurp)" - | wl-copy; kill $PID'))
          hl.bind("CTRL + Print", hl.dsp.exec_cmd('grim - | wl-copy'))
          hl.bind("SUPER + Print", hl.dsp.exec_cmd('wayfreeze & PID=$!; sleep .1; grim -g "$(slurp -o -r -c \'##ff0000ff\')" -t ppm - | ${lib.getExe pkgs.satty} --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date \'+%Y%m%d-%H:%M:%S\').png; kill $PID'))
          hl.bind("SUPER + CTRL + Print", hl.dsp.exec_cmd('grim  -t ppm - | ${lib.getExe pkgs.satty} --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date \'+%Y%m%d-%H:%M:%S\').png'))
        '';

      };
    };
}
