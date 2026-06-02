{ ... }@top:
let
  resize = top.config.utils.otterResize;
in
{
  w.default =
    {
      config,
      scheme,
      self',
      pkgs,
      lib,
      ...
    }:
    let
      theme = config.theme.variant;
      set = _: { };
    in
    {
      wrappers.niri.settings = {
        binds."Mod+Space" = _: {
          content.spawn-sh = "pkill otter-launcher || kitty -1 --app-id=otter -e otter-launcher";
          props.repeat = false;
        };

        window-rules = [
          (
            {
              matches = [ { app-id = "^otter$"; } ];
              open-floating = true;
              default-column-width.fixed = 768;
              default-window-height.fixed = 351;
              focus-ring.off = set;
              border =
                let
                  gradient = _: {
                    props = {
                      to = scheme.withHashtag.bright-cyan;
                      from = "#f3f0e7";
                      angle = 70;
                    };
                  };
                in
                {
                  on = set;
                  width = 3;
                  active-gradient = gradient;
                  inactive-gradient = gradient;
                };
            }
            // lib.optionalAttrs (theme == "dark") {
              default-column-width.fixed = 444;
              default-window-height.fixed = 1108;
            }
          )
          {
            matches = [ { app-id = "^color-picker$"; } ];
            open-floating = true;
            default-column-width.fixed = 730;
            default-window-height.fixed = 330;
          }
        ];
      };

      wrappers.otter-launcher = {
        enable = true;

        settings = {
          general = {
            callback = "";
            cheatsheet_entry = "?";
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
              s = string: builtins.fromJSON ''"${string}"'';

              cpu = "i9 10900K";
              gpu = "RX 6700 XT";
              host = "$(echo $HOSTNAME)";
              res = "$(res '\${width}x\${height}')";
              mem = "$(mem '\${gb_used}G󰿟\${gb_total}G')";
              osver = "NixOS $(grep '^VERSION_ID=' /etc/os-release | cut -d'\"' -f2)";
              kernel = ''$(uname -r | sd "os-lto" "")'';
            in
            {
              header = ''
                ${a "96"}▐${a "3;30;106"}$USER @ ${host} 󱥐 $(date "+%a %m/%d %I:%M%P")${a "0"}${a "96"}▌
                ${a "96"}┏━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━┓
                ${a "96"}┃${a "94"}   ${cpu}  ${a "96"}┃ ${a "94"}  ${kernel}${a "96"}┃
                ${a "96"}┃${a "93"} 󰾲  ${gpu} ${a "96"}┃ ${a "93"}  ${osver}   ${a "96"}┃
                ${a "96"}┃${a "95"}   $(printf "%-10s" ${mem})    ${a "96"}┃ ${a "95"}  $XDG_CURRENT_DESKTOP          ${a "96"}┃
                ${a "96"}┃${a "92"} 󰹑  ${res}  ${a "96"}┃ ${a "92"}  $TERMINAL         ${a "96"}┃
                ${a "96"}┃${a "91"} 󰄉  $(printf "%-10s" "$(upt)") ${a "96"}┃ ${a "91"}  fish          ${a "96"}┃
                ${a "96"}┗━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━┛
                ${a "97"} ${a "92"}'';
              hint_color = "${a "90"}";
              list_prefix = "  ${a "94"}";
              place_holder = "Search...";
              place_holder_color = "${a "1;90"}";
              prefix_color = "${a "93"}";
              default_module_message = "  ${a "3;1;93"} Launch app";
              selection_prefix = "${a "91"} ";
              prefix_padding = 4;
              suggestion_lines = 4;
              suggestion_mode = "list";
              indicator_no_arg_module = "${a "94"} ${a "90"}";
              indicator_with_arg_module = "${a "95"}󰈽 ${a "90"}";
            }
            // lib.optionalAttrs (theme == "light") {
              move_interface_right = 27;
            }
            // lib.optionalAttrs (theme == "dark") {
              header_cmd = "chafa -s x26 $HOME/Pictures/asuka/ao1ifh7efgd61.jpg";
              header = ''
                ${a "31"}  ██${a "91"}▄${a "0"}  ${a "32"}██${a "92"}▄${a "0"}  ${a "33"}██${a "93"}▄${a "0"}  ${a "34"}██${a "94"}▄${a "0"}  ${a "35"}██${a "95"}▄${a "0"}  ${a "36"}██${a "96"}▄${a "0"}  ${a "37"}██${a "97"}▄${a "0"}
                ${a "91"}   ▀▀   ${a "92"}▀▀   ${a "93"}▀▀   ${a "94"}▀▀   ${a "95"}▀▀   ${a "96"}▀▀   ${a "97"}▀▀${a "0"}
                ${a "94"}   $(date "+%a %m/%d 󰥔 %I:%M") $(echo " $(upt)" | sed -e :a -r -e 's/^.{1,12}$/ &/;ta')
                ${a "34"}   $USER@${host} $(echo "  ${kernel}" | sed -e :a -r -e 's/^.{1,17}$/─&/;ta')
                ${a "96"}   ${osver} ────── 󰾲 ${gpu}
                ${a "36"}   ${cpu} $(echo " 󰹑  ${res}" | sed -e :a -r -e 's/^.{1,20}$/─&/;ta')
                ${a "91"}   ${mem} ────────────────  $TERMINAL
                ${a "31"}   $XDG_CURRENT_DESKTOP ───────────────────  fish
                ${a "90"}        ${a "3;97"}'';
              list_prefix = "         ";
              selection_prefix = "       -> ";
              default_module_message = "       ${a "3;1;93"} Launch app";
              footer = " ";
              place_holder_color = "${a "3;1;90"}";
              suggestion_lines = 4;
            };

        };

        modules = [
          {
            description = "run commands";
            prefix = "sh";
            cmd = ''$(printf $TERM | sd 'xterm-' "") -e sh -c " { } "'';
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
            description = if (theme == "light") then "system monitor" else "sys monitor";
            prefix = "btop";
            cmd = resize 2100 1200 "btop";
          }
          {
            description = if (theme == "light") then "interactive systemd" else "iSystemd";
            prefix = "isd";
            cmd = resize 2100 1200 "isd";
          }
          {
            description = "volume mixer";
            prefix = "mix";
            cmd = resize 800 500 "pulsemixer";
          }
          {
            description = "open yazi";
            prefix = "y";
            cmd = resize 2100 1200 "yazi";
          }
          {
            description = if (theme == "light") then "list USB devices" else "USB devices";
            prefix = "usb";
            cmd =
              resize 720 500
                "${lib.getExe pkgs.cyme} --headings --tree --hide-buses;read -p 'Press ENTER to exit. '";
          }
          {
            description = if (theme == "light") then "view wifi networks" else "wifi networks";
            prefix = "wifi";
            cmd = resize 1200 1200 (lib.getExe pkgs.wifitui);
          }
          {
            description = if (theme == "light") then "manage bluetooth" else "bluetooth";
            prefix = "blue";
            cmd = resize 1200 600 (lib.getExe pkgs.bluetuith);
          }
          {
            description = "world clocks";
            prefix = "time";
            cmd = resize 1660 330 "worldclocks";
          }
          {
            description = "color picker";
            prefix = "cc";
            cmd = "niri msg action spawn -- ${pkgs.writeShellScript "color-picker" ''
              sleep 0.25
              PICKED=$(${pkgs.hyprpicker}/bin/hyprpicker --radius=70 --scale=3 --autocopy --no-fancy --format=hex)
              if [ -n "$PICKED" ]; then
                kitty --app-id=color-picker -e sh -c "${pkgs.pastel}/bin/pastel color '$PICKED'; echo; read -n 1 -s -r -p 'Press any key to close...'"
              fi
            ''}; exit";
          }

        ];
      };

      _file = ./settings.nix;
    };
}
