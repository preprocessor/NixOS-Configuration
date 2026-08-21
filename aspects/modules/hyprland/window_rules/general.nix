{
  exo.mods.desktop = {
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

      windowrules.general = [
        {
          # Fix some dragging issues with XWayland
          name = "fix-drag";
          match = {
            class = "^$";
            title = "^$";
            xwayland = true;
            float = true;
            fullscreen = false;
            pin = false;
          };
          rules.no_focus = true;

        }

        {
          # Ignore maximize requests from all apps
          name = "suppress-maximize-events";
          match.class = ".*";
          rules.suppress_event = "maximize";
        }

        # Hyprland-run windowrule
        {
          name = "move-hyprland-run";
          match.class = "hyprland-run";
          rules = {
            move = [
              20
              "monitor_h-120"
            ];
            float = true;
          };
        }

        {
          name = "popin floats";
          match.float = true;
          rules.animation = "popin";
        }

        {
          name = "pip";
          match.title = "^[Pp]icture[- ]in[- ][Pp]icture$";
          rules = {
            size = [
              560
              315
            ];
            move = [
              "monitor_w - window_w - 100"
              "monitor_h - window_h - 100"
            ];
            pin = true;
            float = true;
          };
        }

        {
          name = "file-chooser";
          match.class = "^FileChooser$";
          rules = {
            size = [
              1700
              1100
            ];
            tag = "+center-float";
          };
        }

        {
          name = "center screen share";
          match.initial_title = "Select what to share";
          rules.tag = "+center-float";
        }
      ];
    };
  };
}
