{
  exo.mods.desktop =
    {
      scheme,
      pkgs,
      ...
    }:

    let
      highlight = scheme.base05;

      powercontrols = pkgs.writeShellScript "powercontrols" ''
        echo ""
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
      my.hyprland.lua.files."keybinds.powercontrols".content = /* lua */ ''
        -- Power Controls
        hl.bind("CTRL + ALT + Delete", function()
          utils.toggle_window("powercontrols", "kitty --class powercontrols -e ${powercontrols}", {
            border_size  = 2,
            pin = true,
            float = true,
            center = true,
            stay_focused = true,
            size = { 160, 130 },
          })
        end)
      '';
    };
}
