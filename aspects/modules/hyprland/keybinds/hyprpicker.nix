{
  exo.mods.desktop =
    { pkgs, ... }:
    let
      bin = pkgs.writeShellScript "color-picker" ''
        sleep 0.25
        PICKED=$(${pkgs.hyprpicker}/bin/hyprpicker --radius=70 --scale=3 --autocopy --no-fancy --format=hex)
        if [ -n "$PICKED" ]; then
          kitty --app-id=color-picker -e sh -c "${pkgs.pastel}/bin/pastel color '$PICKED'; echo; read -n 1 -s -r -p 'Press any key to close...'"
        fi
      '';
    in
    {
      my.hyprland = {
        lua.files."keybinds.hyprpicker".content = /* lua */ ''
          hl.bind("SUPER + Y", hl.dsp.exec_cmd("${bin}"))
        '';

        windowrules.general = [
          {
            name = "float-color-picker";
            match.class = "^color-picker$";
            rules = {
              size = [
                680
                270
              ];
              float = true;
            };
          }
        ];
      };
    };
}
