{ lib, ... }:
{
  perSystem =
    { pkgs, config, ... }:
    let
      scheme = config.scheme.withHashtag;
    in
    {
      packages =
        let
          tela-blue = scheme.blue;
          # copy the generated theme directly
          tela-template = pkgs.runCommand "tela-template" { } /* sh */ ''
            # copy the nix icon
            mkdir -p $out/scalable/mimetypes/
            cp ${./nix.svg} $out/scalable/mimetypes/text-x-nix.svg

            # copy everything that is not "@2x", can be generated later
            src="${pkgs.tela-icon-theme}/share/icons/Tela-blue-dark/"
            find "$src" -maxdepth 1 -mindepth 1 ! -name '*@2x' -print0 | xargs -0 -I{} cp -rL {} "$out/"

            # replace video icon color so it can be dynamic
            chmod -R +w "$out"
            find "$out" -type f -name "*.svg" -exec sed -i \
              -e 's/#209ae7/${tela-blue}/g' \
              -e 's/#4154ba/${tela-blue}/g' \
              {} +

            # generate a list of all the files that need to be replaced
            ${lib.getExe pkgs.ripgrep} -l "${tela-blue}" $out | sed "s|$out/||" > $out/replacements.txt
          '';
        in
        {
          # inherit tela-template;
          tela-dynamic-icon-theme =
            # just replace all instances of tela blue
            pkgs.writeShellApplication {
              name = "tela-dynamic-icon-theme";
              runtimeInputs = [
                pkgs.dconf
              ];
              text = /* sh */ ''
                if [[ -z "''${1:-}" ]]; then
                    echo "ERROR: A hex color is required. (e.g. #FFFFFF)"
                    exit 1
                fi

                # strip the leading #
                THEME_NAME="Tela-''${1#\#}"
                THEME_DIR="/tmp/$THEME_NAME"

                # uncomment for debugging
                # rm -rf "$THEME_DIR"

                if [[ ! -d "$THEME_DIR" ]]; then
                  cp -r ${tela-template} "$THEME_DIR"
                  chmod -R +w "$THEME_DIR"

                  # replace only for the files in replacements.txt
                  xargs -d '\n' -a "$THEME_DIR/replacements.txt" -I {} sed -i "s/${tela-blue}/$1/g" "$THEME_DIR/{}"

                  # generate the 2x icon symlinks
                  for dir in 16 22 24 32 scalable;
                    do ln -sr "$THEME_DIR/$dir" "$THEME_DIR/$dir@2x";
                  done
                fi

                mkdir -p "$HOME/.local/share/icons"
                ln -sfn "$THEME_DIR" "$HOME/.local/share/icons/$THEME_NAME"
                dconf write "/org/gnome/desktop/interface/icon-theme" "'$THEME_NAME'"
              '';
            };
        };
    };

  flake.modules.nixos.default =
    { pkgs, ... }:
    {
      options.custom = {
        gtk = {
          iconTheme = {
            package = lib.mkOption {
              type = lib.types.package;
              default = pkgs.tela-icon-theme;
              description = "Package providing the icon theme.";
            };

            name = lib.mkOption {
              type = lib.types.str;
              default = "Tela-blue-dark";
              description = "The name of the icon theme within the package.";
            };
          };
        };
      };
    };

  flake.modules.nixos.desktop =
    { config, pkgs, ... }:
    {
      environment.systemPackages = [
        # use base tela icon theme that will be replaced by dynamic one at startup
        config.custom.gtk.iconTheme.package
        # associate nix files with nix icon
        (pkgs.writeTextFile {
          name = "nix-mimetype";
          destination = "/share/mime/packages/nix.xml";
          text = ''
            <?xml version="1.0" encoding="UTF-8"?>
            <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
                <mime-type type="text/x-nix">
                    <glob pattern="*.nix"/>
                    <icon name="text-x-nix"/>
                </mime-type>
            </mime-info>
          '';
        })
      ];
    };
}
