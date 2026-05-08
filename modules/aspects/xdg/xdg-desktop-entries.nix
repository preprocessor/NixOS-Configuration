{
  w.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      makeFile =
        name: cfg:
        pkgs.makeDesktopItem {
          inherit name;
          inherit (cfg)
            type
            exec
            icon
            comment
            terminal
            genericName
            startupNotify
            noDisplay
            prefersNonDefaultGPU
            actions
            ;
          desktopName = cfg.name;
          mimeTypes = lib.optionals (cfg.mimeType != null) cfg.mimeType;
          categories = lib.optionals (cfg.categories != null) cfg.categories;
          extraConfig = cfg.settings;
        };
    in
    {
      config = {
        hj.packages = config.custom.xdg.desktopEntries |> lib.mapAttrsToList makeFile |> map lib.hiPrio;
        custom.xdg.desktopEntries = {
          "yazi" = {
            name = "Yazi";
            noDisplay = true;
          };
          "qt5ct" = {
            name = "Qt5 Configuration Tool";
            noDisplay = true;
          };
          "qt6ct" = {
            name = "Qt6 Configuration Tool";
            noDisplay = true;
          };
          "nixos-manual" = {
            name = "NixOS Manual";
            noDisplay = true;
          };
          "btop" = {
            name = "btop++";
            noDisplay = true;
          };
          "umpv" = {
            name = "umpv Media Player";
            noDisplay = true;
          };
          "nvim" = {
            name = "Neovim Wrapper";
            noDisplay = true;
          };
          "org.jellyfin.JellyfinDesktop" = {
            name = "Jellyfin";
            icon = "org.jellyfin.JellyfinDesktop";
            exec = "${pkgs.jellyfin-desktop}/bin/jellyfin-desktop --platform xcb";
          };
          "jellyfin-tui" = {
            name = "jellyfin-tui";
            noDisplay = true;
          };
        };
      };
    };
  w.default =
    { lib, ... }:
    let
      inherit (lib) mkOption types;

      desktopEntry = {
        options = {
          type = mkOption {
            description = "The type of the desktop entry.";
            default = "Application";
            type = types.enum [
              "Application"
              "Link"
              "Directory"
            ];
          };
          exec = mkOption {
            description = "Program to execute, possibly with arguments.";
            type = types.nullOr types.str;
            default = null;
          };
          icon = mkOption {
            description = "Icon to display in file manager, menus, etc.";
            type = with types; nullOr (either str path);
            default = null;
          };
          comment = mkOption {
            description = "Tooltip for the entry.";
            type = types.nullOr types.str;
            default = null;
          };
          terminal = mkOption {
            description = "Whether the program runs in a terminal window.";
            type = types.nullOr types.bool;
            default = false;
          };
          name = mkOption {
            description = "Specific name of the application.";
            type = types.str;
          };
          genericName = mkOption {
            description = "Generic name of the application.";
            type = types.nullOr types.str;
            default = null;
          };
          mimeType = mkOption {
            description = "The MIME type(s) supported by this application.";
            type = types.nullOr (types.listOf types.str);
            default = null;
          };
          categories = mkOption {
            description = "Categories in which the entry should be shown in a menu.";
            type = types.nullOr (types.listOf types.str);
            default = null;
          };
          startupNotify = mkOption {
            description = "If true, it is KNOWN that the app will send a remove message.";
            type = types.nullOr types.bool;
            default = null;
          };
          noDisplay = mkOption {
            description = "Means this application exists, but don't display it in the menus.";
            type = types.nullOr types.bool;
            default = null;
          };
          prefersNonDefaultGPU = mkOption {
            description = "If true, the application prefers to be run on a more powerful discrete GPU.";
            type = types.nullOr types.bool;
            default = null;
          };
          settings = mkOption {
            type = types.attrsOf types.str;
            description = "Extra key-value pairs to add to the `[Desktop Entry]` section.";
            default = { };
          };
          actions = mkOption {
            type = types.attrsOf (
              types.submodule (
                { name, ... }:
                {
                  options = {
                    name = mkOption {
                      type = types.str;
                      default = name;
                      description = "Name of the action.";
                    };
                    exec = mkOption {
                      type = types.nullOr types.str;
                      default = null;
                      description = "Program to execute.";
                    };
                    icon = mkOption {
                      type = with types; nullOr (either str path);
                      default = null;
                      description = "Icon to display.";
                    };
                  };
                }
              )
            );
            default = { };
            description = "The set of actions made available to application launchers.";
          };
        };
      };
    in
    {
      options.custom.xdg.desktopEntries = mkOption {
        description = "Custom Desktop Entries";
        default = { };
        type = desktopEntry |> types.submodule |> types.attrsOf;
      };
    };
}
