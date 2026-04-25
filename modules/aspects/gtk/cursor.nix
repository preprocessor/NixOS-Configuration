{ self, lib, ... }:
{
  w.desktop =
    { pkgs, config, ... }:
    let
      cursor = {
        package = pkgs.posy-cursors;
        name = "Posy_Cursor_Black";
        size = 32;
      };

      default_cursor_path = "${cursor.package}/share/icons/${cursor.name}/cursors/left_ptr";

      default_index_theme_package = pkgs.writeTextFile {
        name = "index.theme";
        destination = "/share/icons/default/index.theme";
        # Set name in icons theme, for compatibility with AwesomeWM etc. See:
        # https://github.com/nix-community/home-manager/issues/2081
        # https://wiki.archlinux.org/title/Cursor_themes#XDG_specification
        text = ''
          [Icon Theme]
          Name=Default
          Comment=Default Cursor Theme
          Inherits=${cursor.name}
        '';
      };
    in
    {
      environment.systemPackages = [
        cursor.package
        default_index_theme_package
      ];

      # Add cursor icon link to $XDG_DATA_HOME/icons as well for redundancy.
      hj.xdg.data.files = {
        "icons/${cursor.name}".source = "${cursor.package}/share/icons/${cursor.name}";
      };

      hj.environment.sessionVariables = {
        XCURSOR_SIZE = cursor.size;
        XCURSOR_THEME = cursor.name;
      };

      hj.files.".icons/default/index.theme".source =
        "${default_index_theme_package}/share/icons/default/index.theme";
      hj.files.".icons/${cursor.name}".source = "${cursor.package}/share/icons/${cursor.name}";

      hj.files.".Xresources".text = ''
        Xcursor.theme = ${cursor.name};
        Xcursor.size = ${toString cursor.size};
      '';

      hj.files.".xprofile".text = ''
        if [ -e "$HOME/.profile" ]; then
          . "$HOME/.profile"
        fi

        # If there are any running services from a previous session.
        # Need to run this in xprofile because the NixOS xsession
        # script starts up graphical-session.target.
        systemctl --user stop graphical-session.target graphical-session-pre.target

        ${lib.getExe pkgs.xsetroot} -xcf ${default_cursor_path} ${toString cursor.size}

        export HM_XPROFILE_SOURCED=1
      '';

      hj.xdg.data.files = {
        "icons/default/index.theme".source =
          "${default_index_theme_package}/share/icons/default/index.theme";
      };
    };

  w.default =
    { pkgs, ... }:
    {
      options.custom = {
        gtk = {
          cursor = {
            package = lib.mkOption {
              type = lib.types.package;
              default = pkgs.posy-cursors;
              description = "Package providing the cursor theme.";
            };

          };
        };
      };
    };
}
