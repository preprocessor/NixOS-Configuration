{
  exo.mods.desktop =
    { pkgs, lib, ... }:
    let
      playerctl = lib.getExe pkgs.playerctl;
    in
    {
      my.hyprland.lua.files = {
        "keybinds.media".content = /* lua */ ''
          -- ░█▄█░█▀▀░█▀▄░▀█▀░█▀█
          -- ░█░█░█▀▀░█░█░░█░░█▀█
          -- ░▀░▀░▀▀▀░▀▀░░▀▀▀░▀░▀

          -- multimedia keys for volume
          hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
            { locked = true, repeating = true })
          hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
            { locked = true, repeating = true })
          hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
            { locked = true, repeating = true })
          hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
            { locked = true, repeating = true })

          -- multimedia keys for playback control
          hl.bind("XF86AudioPause", hl.dsp.exec_cmd("${playerctl} play-pause"), { locked = true })
          hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("${playerctl} play-pause"), { locked = true })
          hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("${playerctl} previous"),   { locked = true })
          hl.bind("XF86AudioNext", hl.dsp.exec_cmd("${playerctl} next"),       { locked = true })
        '';
      };
    };
}
