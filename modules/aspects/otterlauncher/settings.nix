{
  w.default =
    { config, ... }:
    {
      custom.programs.otter-launcher = {
        enable = true;
        settings = {
          general = {
            # module to run when no prefix is matched
            default_module = "np";

            # run with an empty prompt
            empty_module = "mix";
            exec_cmd = "sh -c";
            vi_mode = false;

            esc_to_abort = true;
            cheatsheet_entry = "?";
            cheatsheet_viewer = "less -R; clear";

            clear_screen_after_execution = true;
            loop_mode = false;
            external_editor = "nvim";
            delay_startup = 0;
            callback = "";
          };

          overlay = {
            overlay_cmd = "chafa -s x12 ${config.hj.directory}/Pictures/avatars/image.png";
            overlay_trimmed_lines = 1;
            move_overlay_right = 30;
            move_overlay_down = 1;
          };

          interface = {
            move_interface_down = 1;
            header = /* bash */ ''
              ┌ \u001B[1;34m  $USER@$(echo $HOSTNAME) \u001B[0m───┐
              │ \u001B[90m󱎘  \u001B[31m󱎘  \u001B[32m󱎘  \u001B[33m󱎘  \u001B[34m󱎘  \u001B[35m󱎘  \u001B[36m󱎘\u001B[0m │
              └ \u001B[36m󱄅 \u001B[1;36m system\u001B[0m     NixOS ┘
              ┌ \u001B[33m \u001B[1;36m wm \u001B[0m         $XDG_CURRENT_DESKTOP ┐
              │ \u001B[31m \u001B[1;36m loads\u001B[0m       $(cat /proc/loadavg | cut -d ' ' -f 1) │
              │ \u001B[32m \u001B[1;36m memory\u001B[0m     $(free -h | awk 'FNR == 2 {print $3}') │
              │ \u001B[90m\u001B[0m  '';
            list_prefix = "    └ \u001B[34m󰅂  ";
            selection_prefix = "    └ \u001B[31m󱓞  ";
            default_module_message = "    └ \u001B[34m  \u001B[33msearch\u001B[0m nixpkgs";

            place_holder = "type & search";
            suggestion_mode = "list";
            suggestion_lines = 4;
            prefix_color = "\u001B[33m";
            description_color = "\u001B[39m";
            place_holder_color = "\u001B[90m";
            hint_color = "\u001B[90m";
          };

          modules = [
            {
              description = "run commands";
              prefix = "sh";
              cmd = ''$(printf $TERM | sed 's/xterm-//g') -e sh -c " { } "'';
              with_argument = true;
              unbind_proc = true;
            }
            {
              description = "nix packages";
              prefix = "np";
              cmd = "xdg-open 'https://search.nixos.org/packages?channel=unstable&query={}'";
              with_argument = true;
              url_encode = true;
              unbind_proc = true;
            }
            {
              description = "nix options";
              prefix = "no";
              cmd = "xdg-open 'https://search.nixos.org/options?channel=unstable&include_home_manager_options=0&include_modular_service_options=0&include_nixos_options=1&query={}'";
              with_argument = true;
              url_encode = true;
              unbind_proc = true;
            }
            {
              description = "sys mon";
              prefix = "btop";
              cmd = ''
                niri msg action set-window-width 2100;niri msg action set-window-height 1200;niri msg action center-window;btop
              '';
            }
            {
              description = "systemd";
              prefix = "isd";
              cmd = ''
                niri msg action set-window-width 2100;niri msg action set-window-height 1200;niri msg action center-window;isd
              '';
            }
            {
              description = "audio";
              prefix = "mix";
              cmd = ''
                niri msg action set-window-width 800;niri msg action set-window-height 500;niri msg action center-window;pulsemixer
              '';
            }
            {
              description = "notepad";
              prefix = "nap";
              cmd = ''
                niri msg action set-window-width 2500;niri msg action set-window-height 1200;niri msg action center-window;nap
              '';
            }
            {
              description = "video";
              prefix = "mpv";
              cmd = "mpv-wlpaste";
            }
          ];
        };
      };
    };
}
