{
  exo.mods.desktop =
    {
      scheme,
      theme,
      pkgs,
      ...
    }:

    let
      highlight = with scheme.withHashtag; if (theme == "light") then bright-cyan else base05;

      powercontrols = pkgs.writeShellScript "powercontrols" ''
        CHOICE=$(gum choose --cursor=" " --cursor.foreground="#fff" --header="" --no-show-help 'Log Out' 'Reboot' 'Power Off')

        if [[ -z $CHOICE ]]; then
          exit 0
        fi

        gum confirm --no-show-help --selected.background="${highlight}" --prompt.foreground="${highlight}" "$CHOICE?" || exit 0

        case $CHOICE in
          "Log Out") command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || uwsm stop ;;
          "Reboot") hyprshutdown -t "Restarting..." --post-cmd "reboot" ;;
          "Power Off") hyprshutdown -t "Shutting down..." --post-cmd "shutdown -P 0" ;;
        esac
      '';
    in
    {
      my.hyprland.lua.files = {
        "keybinds.base".content = /* lua */ ''
          -- Close
          hl.bind("SUPER + CTRL + Q", hl.dsp.window.close())
          -- Float
          hl.bind("SUPER + Backslash", function() utils.float_center() end)
        '';

        "keybinds.powercontrols".content = /* lua */ ''
          -- Power Controls
          hl.bind("CTRL + ALT + Delete", function()
            utils.toggle_window("powercontrols", "kitty --class powercontrols -e ${powercontrols}", {
              border_size  = 2,
              pin = true,
              float = true,
              center = true,
              stay_focused = true,
              size = { 260, 110 },
            })
          end)
        '';

        "keybinds.zoom".content = /* lua */ ''
          local MAX_ZOOM = 5
          local MIN_ZOOM = 1
          local ZOOM_TOGGLE_FACTOR = 5

          ---@param offset number
          ---@return nil
          local function zoom(offset)
            local current = hl.get_config("cursor.zoom_factor")
            if offset ~= nil then
              current = current + offset
            elseif current ~= MIN_ZOOM then
              current = MIN_ZOOM
            else
              current = ZOOM_TOGGLE_FACTOR
            end
            current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
            hl.config({ cursor = { zoom_factor = current } })
          end

          hl.bind("SUPER + Z", zoom)
          hl.bind("SUPER + KP_Add", function()
            zoom(0.5)
          end)
          hl.bind("SUPER + KP_Subtract", function()
            zoom(-0.5)
          end)
        '';
      };
    };
}
