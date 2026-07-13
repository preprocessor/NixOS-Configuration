{
  exo.mods.desktop = {
    my.hyprland.lua.files = {
      "window_rules.general".content = /* lua */ ''
        hl.window_rule({
          -- Fix some dragging issues with XWayland
          name     = "fix-xwayland-drags",
          match    = {
            class      = "^$",
            title      = "^$",
            xwayland   = true,
            float      = true,
            fullscreen = false,
            pin        = false,
          },

          no_focus = true,
        })

        hl.window_rule({
          -- Ignore maximize requests from all apps
          name           = "suppress-maximize-events",
          match          = { class = ".*" },

          suppress_event = "maximize",
        })

        -- Hyprland-run windowrule
        hl.window_rule({
          name  = "move-hyprland-run",
          match = { class = "hyprland-run" },

          move  = "20 monitor_h-120",
          float = true,
        })

        hl.layer_rule({
          match   = { namespace = "^(wayfreeze)$" },
          no_anim = true,
        })

        hl.layer_rule({
          match     = { namespace = "^(selection)$" },
          animation = "fade"
        })

        hl.window_rule({
          match = {
            float = true,
          },

          animation = "popin"
        })


        hl.window_rule({
          name  = "pip",
          match = {
            title = "^Picture[- ]in[- ][Pp]icture$"
          },

          size = { "560", "315" },
          move  = { "monitor_w - window_w - 100", "monitor_h - window_h - 100" },
          pin   = true,
          float = true,
        })

        hl.window_rule({
          name         = "file-chooser",
          match        = { class = "^FileChooser$" },

          size         = { 1700, 1100 },
          tag = "+center-float"
        })

        hl.window_rule({
          match = { initial_title = "Select what to share" },
          tag = "+center-float"
        })
      '';
    };
  };
}
