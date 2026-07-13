{
  exo.mods.desktop = {
    my.hyprland.lua.files = {
      "keybinds.hide_windows".content = /* lua */ ''
        hl.bind("SUPER + B", function()
          local win = hl.get_active_window()
          if not win then return end
          hl.dispatch(hl.dsp.window.tag({ tag = "hidden", window = win }))
        end)
      '';

      "window_rules.hide_windows".content = /* lua */ ''
        hl.window_rule({
          name = "hide windows",
          match = {
            tag = "hidden"
          },
          no_screen_share = true,
          border_color = "rgb(ff0d2d)",
        })

        hl.window_rule({
          name = "hide logins",
          match = {
            title = "(login|signin|log in|sign in|mail)"
          },
          tag = "+hidden"
        })
      '';
    };
  };
}
