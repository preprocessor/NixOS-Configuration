{
  modules.features.desktop = {
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

      windowrules = {
        tags = [
          {
            name = "hide rule";
            match.tag = "hidden";
            rules.no_screen_share = true;
          }
        ];

        hidden_windows = (
          [
            "login"
            "signin"
            "[Ll]og in"
            "[Ss]ign in"
            "[Mm]ail"
          ]
          |> map (title: {
            match = { inherit title; };
            rules.tag = "+hidden";
          })
        );
      };
    };
  };
}
