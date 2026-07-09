{
  inputs.hyprland = {
    url = "github:hyprwm/Hyprland";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  w.desktop =
    { inputs', ... }:
    {
      custom.programs.hyprland = {
        enable = true;
        package = inputs'.hyprland.packages.hyprland;
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
          render = { direct_scanout = 2 },

          cursor = {
            inactive_timeout = 5000,
            hide_on_key_press = true,
            zoom_disable_aa = true,
            no_warps = true,
            persistent_warps = true,
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

        -- Restore wallpaper on monitor reconnect
        hl.on("monitor.added", function()
          hl.dispatch(hl.dsp.exec_raw("waypaper --restore"))
        end)
      '';
    };
}
