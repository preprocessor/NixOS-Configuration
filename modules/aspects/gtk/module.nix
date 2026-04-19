# Based on: https://github.com/iynaix/dotfiles/blob/7cfd3aec29feec3807206591260e594ad28094f9/modules/gui/gtk/default.nix
{ lib, ... }:
{
  w.default =
    { config, pkgs, ... }:
    let
      inherit (lib) mkOption types literalExpression;
    in
    {
      options.custom = {
        # type referenced from nixpkgs:
        # https://github.com/NixOS/nixpkgs/blob/554be6495561ff07b6c724047bdd7e0716aa7b46/nixos/modules/programs/dconf.nix#L121C9-L134C11
        dconf.settings = mkOption {
          type = types.attrs;
          default = { };
          description = "An attrset used to generate dconf keyfile.";
          example = literalExpression ''
            with lib.gvariant;
            {
              "com/raggesilver/BlackBox" = {
                scrollback-lines = mkUint32 10000;
                theme-dark = "Tommorrow Night";
              };
            }
          '';
        };
        gtk = {
          bookmarks = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [ "/home/jane/Documents" ];
            description = "File browser bookmarks.";
          };

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

          theme = {
            package = lib.mkOption {
              type = lib.types.package;
              default = pkgs.tokyonight-dynamic-gtk-theme;
              description = "Package providing the theme.";
            };

            name = lib.mkOption {
              type = lib.types.str;
              default = "Tokyonight-Dark-Compact";
              description = "The name of the theme within the package.";
            };
          };
        };
      };

    };
}
