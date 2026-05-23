{ ... }@top:
let
  resize = top.config.utils.otterResize;
in
{
  envoy.fsel.github = "Mjoyufull/fsel";

  perSystem =
    { pkgs, envoy, ... }:
    {
      packages.fsel = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
        inherit (envoy.fsel) pname version src;
        cargoLock.lockFile = finalAttrs.src + "/Cargo.lock";
      });
    };

  w.default =
    {
      config,
      self',
      pkgs,
      lib,
      ...
    }:
    let
      esc = (builtins.fromTOML ''value = "\u001b"'').value;
      scheme = config.scheme.withHashtag;
      set = _: { };
    in
    {
      wrappers.niri.settings = {
        binds."Mod+Space" = _: {
          content.spawn-sh = "pkill otter-launcher || kitty -1 --app-id=otter -e otter-launcher";
          props.repeat = false;
        };

        window-rules = [
          {
            matches = [ { app-id = "^otter$"; } ];
            open-floating = true;
            default-column-width.fixed = 704;
            default-window-height.fixed = 350;
            focus-ring.off = set;
            border =
              let
                gradient = _: {
                  props = {
                    to = scheme.bright-cyan;
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

          overlay = {
            overlay_cmd = "chafa -s x14 $HOME/Pictures/avatars/ramiel/drawn2.jpg";
            overlay_trimmed_lines = 1;
          };

          interface = {
            header = ''
              ${esc}[0;36m▐${esc}[0;30m${esc}[46m${esc}[3m$USER @ $(echo $HOSTNAME) 󱥐 $(date "+%a %m/%d %I:%M%P")${esc}[0m${esc}[0;36m▌${esc}[0m
              ${esc}[0;36m┏━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━┓
              ${esc}[0;36m┃${esc}[0;34m   i9-10900K  ${esc}[0;36m┃ ${esc}[0;34m  $(uname -r | sd "\-lto" "") ${esc}[0;36m┃
              ${esc}[0;36m┃${esc}[0;93m 󰾲  RX 6700 XT ${esc}[0;36m┃ ${esc}[0;93m  NixOS $(grep '^VERSION_ID=' /etc/os-release | cut -d'"' -f2)   ${esc}[0;36m┃
              ${esc}[0;36m┃${esc}[0;35m   $(printf "%-10s" "$(mem ' ''${gb_used}G󰿟''${gb_total}G')")    ${esc}[0;36m┃ ${esc}[0;35m  $XDG_CURRENT_DESKTOP          ${esc}[0;36m┃
              ${esc}[0;36m┃${esc}[0;32m 󰹑  $(res ' ''${width}x''${height}')  ${esc}[0;36m┃ ${esc}[0;32m  $TERMINAL         ${esc}[0;36m┃
              ${esc}[0;36m┃${esc}[0;31m 󰄉  $(printf "%-10s" "$(upt)") ${esc}[0;36m┃ ${esc}[0;31m  fish          ${esc}[0;36m┃
              ${esc}[0;36m┗━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━┛
              ${esc}[0;97m ${esc}[0;32m'';
            hint_color = "${esc}[90m";
            list_prefix = "  ${esc}[34m";
            place_holder = "Search...";
            place_holder_color = "${esc}[1;90m";
            prefix_color = "${esc}[33m";
            selection_prefix = "${esc}[31m ";
            prefix_padding = 4;
            suggestion_lines = 4;
            suggestion_mode = "list";
            indicator_no_arg_module = "${esc}[34m ${esc}[90m";
            indicator_with_arg_module = "${esc}[35m󰈽 ${esc}[90m";
            move_interface_right = 27;
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
              description = "system monitor";
              prefix = "btop";
              cmd = resize 2100 1200 "btop";
            }
            {
              description = "interactive systemd";
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
              description = "list USB devices";
              prefix = "usb";
              cmd =
                resize 720 500
                  "${lib.getExe pkgs.cyme} --headings --tree --hide-buses;read -p 'Press ENTER to exit. '";
            }
            {
              description = "view wifi networks";
              prefix = "wifi";
              cmd = resize 1200 1200 (lib.getExe pkgs.wifitui);
            }
            {
              description = "manage bluetooth";
              prefix = "blue";
              cmd = resize 1200 600 (lib.getExe pkgs.bluetuith);
            }
            {
              description = "world clocks";
              prefix = "time";
              cmd = resize 1660 330 "worldclocks";
            }
          ];
        };
      };

      _file = ./settings.nix;
    };
}
