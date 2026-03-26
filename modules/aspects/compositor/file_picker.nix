{
  flake.modules.nixos.desktop =
    {
      lib,
      pkgs,
      ...
    }:
    {
      xdg.portal = {
        extraPortals = [ pkgs.xdg-desktop-portal-termfilechooser ];
        config.common = {
          "org.freedesktop.impl.portal.FileChooser" = lib.mkForce [
            "termfilechooser"
          ];
        };
      };
    };

  flake.modules.homeManager.default =
    { pkgs, config, ... }:
    {
      xdg.configFile = {
        "xdg-desktop-portal-termfilechooser/config".text = # toml
          ''
            [filechooser]
            cmd=yazi-wrapper.sh
            default_dir=${config.xdg.userDirs.download}
            open_mode=default
            save_mode=default
          '';

        "xdg-desktop-portal-termfilechooser/yazi-wrapper.sh" = {
          executable = true;
          text = # bash
            ''
              #!/usr/bin/env sh
              set -e

              if [ "$6" -ge 4 ]; then
                  set -x
              fi

              multiple="$1"
              directory="$2"
              save="$3"
              path="$4"
              out="$5"

              command="${pkgs.foot}/bin/foot --app-id=FileChooser -e ${pkgs.yazi}/bin/yazi"

              if [ "$save" = "1" ]; then
                  set -- --chooser-file="$out" "$path"
              elif [ "$directory" = "1" ]; then
                  set -- --chooser-file="$out" --cwd-file="$out"".1" "$path"
              elif [ "$multiple" = "1" ]; then
                  set -- --chooser-file="$out" "$path"
              else
                  set -- --chooser-file="$out" "$path"
              fi

              for arg in "$@"; do
                  escaped=$(printf "%s" "$arg" | sed 's/"/\\"/g')
                  command="$command \"$escaped\""
              done

              sh -c "$command"

              if [ "$directory" = "1" ]; then
                  if [ ! -s "$out" ] && [ -s "$out"".1" ]; then
                      cat "$out"".1" > "$out"
                      rm "$out"".1"
                  else
                      rm "$out"".1"
                  fi
              fi
            '';
        };
      };
    };
}
