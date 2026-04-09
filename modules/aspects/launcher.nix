{ inputs, self, ... }:
{
  flake-file.inputs.vicinae.url = "github:vicinaehq/vicinae";
  flake-file.inputs.vicinae-extensions.url = "github:vicinaehq/extensions";

  flake.modules.homeManager.default =
    { pkgs, ... }:
    {
      imports = [ inputs.vicinae.homeManagerModules.default ];

      nix.settings = {
        extra-substituters = [ "https://vicinae.cachix.org" ];
        extra-trusted-public-keys = [ "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" ];
      };

      # systemd.user.services.vicinae.Service.Environment = [
      #   "PATH=/etc/profiles/per-user/${self.const.username}/bin"
      #   "PATH=/run/current-system/sw/bin"
      # ];

      services.vicinae = {
        enable = true;
        package = pkgs.vicinae;
        systemd = {
          enable = true; # default: false
          autoStart = true; # default: false
          environment = {
            USE_LAYER_SHELL = 1;
          };
        };

        settings = {
          close_on_focus_loss = true;
          consider_preedit = true;
          activate_on_single_click = true;
          pop_to_root_on_close = true;
          favicon_service = "twenty";
          search_files_in_root = true;
          font = {
            normal = {
              family = "SF Pro Text";
              size = 12;
            };
          };
          theme = {
            light = {
              name = "vicinae-dark";
              icon_theme = "default";
            };
            dark = {
              name = "vicinae-dark";
              icon_theme = "default";
            };
          };
          launcher_window = {
            opacity = 0.98;
            blur.enabled = true;

            client_side_decorations = {
              enabled = true;
              rounding = 0;
              border_width = 5;
            };

            # In compact mode, vicinae only shows a search bar in the root search if no query is entered, only expanding to its full size when searching.
            # WARNING: compact mode works best when vicinae is rendered as a layer surface (the default if available), as opposed to a regular floating window.
            # That's because the part that is not rendered in compact mode is still part of the full window size, allowing the window to be gracefully expanded without having to deal
            # with a compositor window resize which can generate a lot of visual noise. Server side borders and blur will look notably out of place.
            compact_mode = {
              enabled = false;
            };

          };
        };
        extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
          bluetooth
          nix
          power-profile
          niri
          # Extension names can be found in the link below, it's just the folder names
          # https://github.com/vicinaehq/extensions/tree/main/extensions
        ];
      };
    };
}
