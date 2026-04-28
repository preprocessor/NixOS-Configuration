{ inputs, self, ... }:
{
  envoy.kitty.github = "kovidgoyal/kitty";

  perSystem =
    { pkgs, envoy, ... }:
    {
      packages.kitty = pkgs.kitty.overrideAttrs (finalAttrs: {
        inherit (envoy.kitty) pname src version;
        pyproject = false;
        dontCheck = true;
        goModules =
          (pkgs.buildGo126Module {
            pname = "kitty-go-modules";
            inherit (finalAttrs) src version;
            vendorHash = "sha256-FaSWBeQJlvw9vXcHJ/OaFd48K8d7X86X8w7wpG84Ltw=";
          }).goModules;
      });
    };

  w.default =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      inherit (lib)
        types
        mkOption
        literalExpression
        ;

      settingsValueType =
        with types;
        oneOf [
          str
          bool
          int
          float
        ];
    in
    {
      config = {
        nixpkgs.overlays = [
          (_: prev: {
            kitty = inputs.wrappers.wrappers.kitty.wrap (
              wrapper:
              let
                cfg = config.custom.programs.kitty;
              in
              {
                pkgs = prev;
                package = self.packages.${prev.stdenv.hostPlatform.system}.kitty;
                inherit (cfg) extraConfig keybindings;
                settings = cfg.settings // {
                  include = wrapper.config.constructFiles.theme.path;
                };
                constructFiles.theme = {
                  relPath = "theme.conf";
                  content = cfg.theme;
                };
              }
            );
          })
        ];

        hj.packages = [ pkgs.kitty ];

      };
      options.custom.programs.kitty = {
        settings = mkOption {
          type = types.attrsOf settingsValueType;
          default = { };
          example = literalExpression ''
            {
              scrollback_lines = 10000;
              enable_audio_bell = false;
              update_check_interval = 0;
            }
          '';
          description = ''
            Key/value pairs written into `kitty.conf`.
            See <https://sw.kovidgoyal.net/kitty/conf.html>.
          '';
        };
        theme = mkOption {
          type = with lib.types; nullOr (either path lines);
          default = "";
          description = ''
            Color scheme for kitty
          '';
        };

        keybindings = mkOption {
          type = types.attrsOf types.str;
          default = { };
          example = literalExpression ''
            {
              "ctrl+c" = "copy_or_interrupt";
              "ctrl+f>2" = "set_font_size 20";
            }
          '';
          description = "Mapping of keybindings to actions.";
        };

        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = "Additional configuration appended verbatim to kitty.conf.";
        };
      };
    };
}
