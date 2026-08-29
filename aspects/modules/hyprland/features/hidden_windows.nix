{
  exo.mods.desktop = {
    my.hyprland = {
      lua.files = {
        "keybinds.hide_windows".content = /* lua */ ''
          hl.bind("SUPER + PERIOD", function()
            local win = hl.get_active_window()
            if not win then return end
            hl.dispatch(hl.dsp.window.tag({ tag = "hidden", window = win }))
          end)
        '';
      };

      windowrules.hide_windows = [
        {
          match.tag = "hidden";
          rules = {
            no_screen_share = true;
            border_color = "#ff0d2d #ff0d2d";
          };
        }
        {
          match.title = "(login|signin|log in|sign in|mail)";
          rules.tag = "+hidden";
        }
      ];
    };
  };
}
