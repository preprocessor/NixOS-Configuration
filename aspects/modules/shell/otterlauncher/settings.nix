{
  exo.mods.desktop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      theme = config.theme.variant;
    in
    {
      my.hyprland.lua.files = {
        "keybinds.otter".content = /* lua */ ''
          -- otter-launcher
          hl.bind("SUPER + Space", function()
            utils.toggle_window(
              "otter.launcher",
              "kitty --class=otter.launcher " ..
              "-e otter-launcher", {
                size         = { 1010, 510 },

                center       = true,
                float        = true,
                stay_focused = true,
                pin          = true,
              }
            )
          end)
        '';

        "window_rules.general".content = /* lua */ ''
          hl.window_rule({
            name = "float color-picker",
            match = {
              class = "^color-picker$"
            },
            float = true,
          })
        '';
      };

      my.otter-launcher = {
        enable = true;

        settings = {
          general = {
            callback = "";
            cheatsheet_entry = "";
            cheatsheet_viewer = "less -R; clear";
            clear_screen_after_execution = true;
            delay_startup = 0;
            esc_to_abort = true;
            exec_cmd = "sh -c";
            external_editor = "nvim";
            loop_mode = false;
            vi_mode = false;
          };

          overlay = lib.optionalAttrs (theme == "light") {
            overlay_cmd = "chafa -s x14 $HOME/Pictures/avatars/ramiel/drawn2.jpg";
            overlay_trimmed_lines = 1;
          };

          interface =
            let
              a = string: builtins.fromJSON ''"\u001B[${string}m"'';

              cpu = "i9 10900K";
              gpu = "RX 6700 XT";

              host = "$(echo $HOSTNAME)";
              res = "$(res '\${width}x\${height}')";
              mem = "$(mem '\${gb_used}G󰿟\${gb_total}G')";
              osver = "NixOS $(grep '^VERSION_ID=' /etc/os-release | cut -d'\"' -f2)";
              kernel = ''$(uname -r | sd "os-lto" "")'';
            in
            {
              suggestion_mode = "list";
              indicator_no_arg_module = "${a "94"} ${a "90"}";
              indicator_with_arg_module = "${a "95"}󰈽 ${a "90"}";
            }
            // lib.optionalAttrs (theme == "light") {
              move_interface_right = 27;
              header = ''
                ${a "96"}▐${a "3;30;106"}$USER @ ${host} 󱥐 $(date "+%a %m/%d %I:%M%P")${a "0"}${a "96"}▌
                ${a "96"}┏━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━┓
                ${a "96"}┃${a "34"}   ${cpu}  ${a "96"}┃ ${a "34"}  $(printf "%-14s" "${kernel}")${a "96"}┃
                ${a "96"}┃${a "33"} 󰾲  ${gpu} ${a "96"}┃ ${a "33"}  ${osver}   ${a "96"}┃
                ${a "96"}┃${a "35"}   $(printf "%-10s" ${mem})    ${a "96"}┃ ${a "35"}  $XDG_CURRENT_DESKTOP          ${a "96"}┃
                ${a "96"}┃${a "32"} 󰹑  ${res}  ${a "96"}┃ ${a "32"}  $TERMINAL         ${a "96"}┃
                ${a "96"}┃${a "31"} 󰄉  $(printf "%-10s" "$(upt)") ${a "93"}┃ ${a "91"}  fish          ${a "96"}┃
                ${a "96"}┗━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━┛
                ${a "97"}  ${a "92"}'';
              hint_color = "${a "91"}";
              list_prefix = "     ${a "94"}";
              place_holder = "Search...";
              place_holder_color = "${a "1;90"}";
              prefix_color = "${a "93"}";
              default_module_message = "${a "93"} Launch app";
              selection_prefix = "   ${a "91"} ";
              prefix_padding = 4;
              suggestion_lines = 4;

            }
            // lib.optionalAttrs (theme == "dark") {
              place_holder = "${a "30"}LOCATE";
              default_module_message = "${a "93"}EXECUTE";
              header = "${a "32"}手${a "37"}";
              list_prefix = "  ";
              selection_prefix = "${a "31;1"}辵";
              prefix_color = "${a "33"}";
              description_color = "${a "39"}";
              place_holder_color = "${a "30"}";
              hint_color = "${a "30"}";
              prefix_padding = 3;
              suggestion_lines = 14;
            };
        };

        modules =
          let
            spawn = config.utils.hyprSpawn;
          in
          [
            {
              description = "bash";
              prefix = "sh";
              cmd = ''$(printf $TERM | sd 'xterm-' "") -e sh -c " { } "'';
              with_argument = true;
              unbind_proc = true;
            }
            {
              description = "nixpkgs";
              prefix = "np";
              cmd = "xdg-open 'https://search.nixos.org/packages?channel=unstable&query={}'";
              with_argument = true;
              url_encode = true;
              unbind_proc = true;
            }
            {
              description = "nixopts";
              prefix = "no";
              cmd = "xdg-open 'https://search.nixos.org/options?channel=unstable&include_home_manager_options=0&include_modular_service_options=0&include_nixos_options=1&query={}'";
              with_argument = true;
              url_encode = true;
              unbind_proc = true;
            }
            {
              description = "monitor";
              prefix = "btop";
              cmd = spawn 2100 1200 "btop" "btop";
            }
            {
              description = "systemd";
              prefix = "isd";
              cmd = spawn 2100 1200 "isd" "isd";
            }
            {
              description = "mixer";
              prefix = "vol";
              cmd = spawn 800 500 "mixer" (lib.getExe pkgs.pulsemixer);
            }
            {
              description = "devices";
              prefix = "usb";
              cmd =
                spawn 720 500 "usb"
                  "${lib.getExe pkgs.cyme} --headings --tree --hide-buses;read -p 'Press ENTER to exit. '";
            }
            {
              description = "networks";
              prefix = "wifi";
              cmd = spawn 1200 1200 "wifi" (lib.getExe pkgs.wifitui);
            }
            {
              description = "tooth";
              prefix = "blue";
              cmd = spawn 1200 600 "bluetooth" (lib.getExe pkgs.bluetuith);
            }
            {
              description = "zones";
              prefix = "time";
              cmd = spawn 1660 330 "worldclocks" "worldclocks";
            }
            {
              description = "color";
              prefix = "pick";
              cmd =
                let
                  bin = pkgs.writeShellScript "color-picker" ''
                    sleep 0.25
                    PICKED=$(${pkgs.hyprpicker}/bin/hyprpicker --radius=70 --scale=3 --autocopy --no-fancy --format=hex)
                    if [ -n "$PICKED" ]; then
                      kitty --app-id=color-picker -e sh -c "${pkgs.pastel}/bin/pastel color '$PICKED'; echo; read -n 1 -s -r -p 'Press any key to close...'"
                    fi
                  '';
                in
                ''hyprctl dispatch "hl.dsp.exec_cmd('${bin}; exit')"'';
            }
          ];
      };

      _file = ./settings.nix;
    };
}
