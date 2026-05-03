{
  w.default =
    { config, self', ... }:
    let
      esc = (builtins.fromTOML ''value = "\u001b"'').value;
    in
    {
      custom.programs.niri.settings = {
        binds."Mod+Space" = _: {
          content.spawn-sh = "pkill otter-launcher || kitty -1 --app-id=otter-launcher -e otter-launcher";
          props.repeat = false;
        };

        window-rules = [
          {
            matches = [ { app-id = "^otter-launcher$"; } ];
            open-floating = true;
            opacity = 0.95;
            default-column-width.fixed = 690;
            default-window-height.fixed = 355;
          }
        ];
      };

      hj.packages = [
        self'.packages.otter-launcher
      ];

      # custom.programs.otter-launcher = {
      # enable = true;
      #   settings = {
      #     general = {
      #       # module to run when no prefix is matched
      #       default_module = "np";
      #
      #       # run with an empty prompt
      #       empty_module = "mix";
      #       exec_cmd = "sh -c";
      #       vi_mode = false;
      #
      #       esc_to_abort = true;
      #       cheatsheet_entry = "?";
      #       cheatsheet_viewer = "less -R; clear";
      #
      #       clear_screen_after_execution = true;
      #       loop_mode = false;
      #       external_editor = "nvim";
      #       delay_startup = 0;
      #       callback = "";
      #     };
      #
      #     overlay = {
      #       overlay_cmd = "chafa -s x12 ${config.hj.directory}/Pictures/avatars/image.png";
      #       # overlay_trimmed_lines = 1;
      #       move_overlay_right = 30;
      #       move_overlay_down = 1;
      #     };
      #
      #     interface = {
      #       move_interface_down = 1;
      #       header = /* bash */ ''
      #         ┌───┐ ${esc}[1;34m   $USER@$hostname ${esc}[0m───┐
      #         │${esc}[48;5;82m${esc}[38;5;8m▌󰮯▐${esc}[0m│ ${esc}[33m ${esc}[1;36m wm ${esc}[0m         $XDG_CURRENT_DESKTOP ┐
      #         │+ ⠔│ ${esc}[31m ${esc}[1;36m cpu${esc}[0m       $(cat /proc/loadavg | cut -d ' ' -f 1) │
      #         └───' ${esc}[32m ${esc}[1;36m mem${esc}[0m   $(mem ' ''${gb_used}GB / ''${gb_total}GB') │
      #               ${esc}[90m${esc}[0m  '';
      #       list_prefix = "    └ ${esc}[34m󰅂  ";
      #       selection_prefix = "    └ ${esc}[31m󱓞  ";
      #       default_module_message = "    └ ${esc}[34m  ${esc}[33msearch${esc}[0m nixpkgs";
      #
      #       place_holder = "type & search";
      #       suggestion_mode = "list";
      #       suggestion_lines = 4;
      #       prefix_color = "${esc}[33m";
      #       description_color = "${esc}[39m";
      #       place_holder_color = "${esc}[90m";
      #       hint_color = "${esc}[90m";
      #     };
      #
      #     modules = [
      #       {
      #         description = "run commands";
      #         prefix = "sh";
      #         cmd = ''$(printf $TERM | sed 's/xterm-//g') -e sh -c " { } "'';
      #         with_argument = true;
      #         unbind_proc = true;
      #       }
      #       {
      #         description = "nix packages";
      #         prefix = "np";
      #         cmd = "xdg-open 'https://search.nixos.org/packages?channel=unstable&query={}'";
      #         with_argument = true;
      #         url_encode = true;
      #         unbind_proc = true;
      #       }
      #       {
      #         description = "nix options";
      #         prefix = "no";
      #         cmd = "xdg-open 'https://search.nixos.org/options?channel=unstable&include_home_manager_options=0&include_modular_service_options=0&include_nixos_options=1&query={}'";
      #         with_argument = true;
      #         url_encode = true;
      #         unbind_proc = true;
      #       }
      #       {
      #         description = "sys mon";
      #         prefix = "btop";
      #         cmd = ''
      #           niri msg action set-window-width 2100;niri msg action set-window-height 1200;niri msg action center-window;btop
      #         '';
      #       }
      #       {
      #         description = "systemd";
      #         prefix = "isd";
      #         cmd = ''
      #           niri msg action set-window-width 2100;niri msg action set-window-height 1200;niri msg action center-window;isd
      #         '';
      #       }
      #       {
      #         description = "audio";
      #         prefix = "mix";
      #         cmd = ''
      #           niri msg action set-window-width 800;niri msg action set-window-height 500;niri msg action center-window;pulsemixer
      #         '';
      #       }
      #       {
      #         description = "notepad";
      #         prefix = "nap";
      #         cmd = ''
      #           niri msg action set-window-width 2500;niri msg action set-window-height 1200;niri msg action center-window;nap
      #         '';
      #       }
      #       {
      #         description = "video";
      #         prefix = "mpv";
      #         cmd = "mpv-wlpaste";
      #       }
      #     ];
      #   };
      # };
    };
}
