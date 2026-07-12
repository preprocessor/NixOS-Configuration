{
  w.desktop =
    { packages', ... }:
    {
      custom.programs.hyprland = {
        enable = true;
        package = packages'.hyprland;
        withUWSM = false;
      };

      custom.programs.hyprland.lua.files."general".content = /* lua */ ''
        hl.monitor({
          output = "DP-2",
          mode = "3440x1440@74.983",
          position = "0x0",
          scale = 1,
        })

        hl.config({
          render = {
            direct_scanout = 2,
          },

          cursor = {
            inactive_timeout = 5000,
            hide_on_key_press = true,
            zoom_disable_aa = true,
            no_warps = true,
            warp_back_after_non_mouse_input = false,
            warp_on_change_workspace = 2,
            warp_on_toggle_special = 2,
          },

          binds = {
            workspace_back_and_forth = true,
          },

          misc = {
            force_default_wallpaper = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
            disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
            focus_on_activate       = true,
            middle_click_paste      = false,
          },

          input = {
            kb_layout          = "us",
            kb_options         = "caps:escape",

            numlock_by_default = true,

            repeat_delay       = 300,
            repeat_rate        = 40,

            follow_mouse       = 2,
          },
        })

        hl.config({
          general = {
            gaps_in          = 15,
            gaps_out         = 25,

            border_size      = 1,

            col              = {
              active_border   = { colors = { "rgb(EC7420)", "rgb(fabd2f)" }, angle = 135 },
              inactive_border = "rgb(aaaaaa)",
            },

            layout           = "lua:centercol",
          },

          decoration = {
            -- Change transparency of focused and unfocused windows
            active_opacity   = 1.0,

            inactive_opacity = 1.0,

            dim_special = 0.8,

            shadow           = {
              enabled        = true,
              range          = 15,
              render_power   = 4,
              color          = 0x0cEC7420,
              color_inactive = 0x00000000,
            },

            blur             = {
              enabled  = true,
              size     = 6,
              passes   = 2,
              vibrancy = 0.1696,
            },
          },

          input = {
            kb_layout          = "us",
            kb_options         = "caps:escape",

            numlock_by_default = true,

            repeat_delay       = 300,
            repeat_rate        = 40,

            follow_mouse       = 2,
          },


          render = {
            direct_scanout = 2,
          },
        })

        -- Restore wallpaper on monitor reconnect
        hl.on("monitor.added", function()
          hl.dispatch(hl.dsp.exec_raw("waypaper --restore"))
        end)
      '';
    };
}
