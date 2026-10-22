{
  exo.mods.desktop =
    { pkgs, ... }:
    let
      powercontrols = pkgs.writeShellScript "powercontrols" ''
        echo -e '\033]2;'Power Controls'\007'
        CHOICE=$(gum choose --cursor=" " --cursor.foreground="#fff" --header="" --no-show-help 'Log Out' 'Reboot' 'Power Off')

        if [[ -z $CHOICE ]]; then
          exit 0
        fi

        clear
        echo -e '\033]2;'Are you sure?'\007'
        CONFIRM=$(gum choose --cursor=" " --cursor.foreground="#fff" --header="" --no-show-help 'Yes' 'No')

        # Exit early unless the user explicitly confirmed (covers "No" and a cancelled/empty selection)
        if [[ $CONFIRM != "Yes" ]]; then
          exit 0
        fi

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
