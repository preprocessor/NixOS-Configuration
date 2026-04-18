{ inputs, ... }:
{
  flake-file.inputs = {
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty-cursor-shaders = {
      url = "github:sahaj-b/ghostty-cursor-shaders";
      flake = false;
    };
  };

  flake.modules.nixos.desktop =
    { pkgs, config, ... }:
    {
      nixpkgs.overlays = [ inputs.ghostty.overlays.default ];

      nix.settings = {
        extra-substituters = [ "https://ghostty.cachix.org" ];
        extra-trusted-public-keys = [ "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns=" ];
      };

      hj.xdg.config.files."ghostty/config".text = ''
        custom-shader = ${inputs.ghostty-cursor-shaders}/cursor_tail.glsl
        font-family = Maple Mono
        font-family-bold = Maple Mono
        font-family-bold-italic = Maple Mono
        font-family-italic = Maple Mono
        font-feature = calt
        font-feature = cv01
        font-feature = cv02
        font-feature = cv03
        font-feature = cv07
        font-feature = cv09
        font-feature = cv10
        font-feature = cv40
        font-feature = cv42
        font-feature = cv43
        font-feature = ss03
        font-feature = ss10
        font-size = 12
        font-style = Medium
        font-style-bold = ExtraBold
        font-style-bold-italic = Bold Italic
        font-style-italic = Italic
        keybind = ctrl+shift+t=unbind
        keybind = ctrl+shift+w=unbind
        keybind = ctrl+shift+n=unbind
        keybind = ctrl+backslash=new_split:down
        keybind = chain=resize_split:down,400
        keybind = performable:ctrl+shift+h=goto_split:left
        keybind = performable:ctrl+shift+j=goto_split:bottom
        keybind = performable:ctrl+shift+k=goto_split:top
        keybind = performable:ctrl+shift+l=goto_split:right
        mouse-hide-while-typing = true
        mouse-scroll-multiplier = 1
        shell-integration = fish
        unfocused-split-opacity = 0.800000
        window-decoration = false
        window-padding-balance = true
        window-save-state = never
      '';

      hj.packages = [ pkgs.ghostty ];

      hj.xdg.config.files."systemd/user/app-com.mitchellh.ghostty.service.d/overrides.conf".text = ''
        [Unit]
        X-SwitchMethod=keep-old
        X-Reload-Triggers=${
          let
            storePathOf = name: config.hj.xdg.config.files.${name}.source;
          in
          toString ([ (storePathOf "ghostty/config") ]
            # ++ lib.mapAttrsToList (name: _: storePathOf "ghostty/themes/${name}") cfg.themes
          )
        }
      '';

      hj.xdg.data.files."dbus-1/services".source = pkgs.symlinkJoin {
        name = "user-dbus-services";
        paths = [ pkgs.ghostty ];
        stripPrefix = "/share/dbus-1/services";
      };

      hj.xdg.config.files."systemd/user/app-com.mitchellh.ghostty.service".source =
        "${pkgs.ghostty}/share/systemd/user/app-com.mitchellh.ghostty.service";

      # programs.fish.interactiveShellInit = ''
      #   if set -q GHOSTTY_RESOURCES_DIR
      #     source "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
      #   end
      # '';
    };
}
