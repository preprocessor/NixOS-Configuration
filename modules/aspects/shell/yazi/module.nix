{
  w.shell =
    {
      pkgs,
      config,
      lib,
      wrappers,
      ...
    }:
    let
      flavorsObject =
        config.custom.programs.yazi.flavors
        |> lib.concatMapAttrs (
          name: repo: {
            "flavor-${name}-toml" = {
              relPath = "yazi-config/flavors/${name}.yazi/flavor.toml";
              content = builtins.readFile "${repo}/flavor.toml";
            };
            "flavor-${name}-tmtheme" = {
              relPath = "yazi-config/flavors/${name}.yazi/tmtheme.xml";
              content = builtins.readFile "${repo}/tmtheme.xml";
            };
          }
        );

      yaziWrapped = wrappers.wrappers.yazi.wrap ({
        inherit pkgs;
        inherit (config.custom.programs.yazi) plugins;
        extraPackages = with pkgs; [
          ouch-rar
          ripgrep
          glow
          git
        ];
        settings = with config.custom.programs.yazi; {
          inherit keymap theme;
          yazi = settings;
        };
        constructFiles = {
          initLua = {
            relPath = "yazi-config/init.lua";
            content = config.custom.programs.yazi.initLua;
          };
        }
        // flavorsObject;
      });
    in
    {
      environment.systemPackages = [ yaziWrapped ];

      programs.fish.functions.y = /* fish */ ''
        set -l tmp (mktemp -t "yazi-cwd.XXXXX")
        command yazi $argv --cwd-file="$tmp"
        if read cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
          builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
      '';
    };

  w.default =
    { pkgs, lib, ... }:
    let
      inherit (pkgs.formats.toml { }) type;
      default = { };
      mkMapOption = description: lib.mkOption { inherit type description default; };
    in
    with lib;
    {
      options.custom.programs.yazi = {
        initLua = mkOption {
          type = with types; nullOr (either path lines);
          default = "";
          description = "The init.lua for Yazi itself.";
          example = literalExpression "./init.lua";
        };

        plugins = mkOption {
          type = with types; attrsOf (nullOr path);
          default = { };
          description = "An attribute set of plugin names and their paths";
          example = literalMD ''
            ```nix
            with pkgs.yaziPlugins; {
              smart-enter = smart-enter;
              drag = inputs.drag;
              gvfs = inputs.gvfs-yazi;
              git = git;
              starship = starship;
              full-border = full-border;
            };
            ```
          '';
        };

        flavors = mkOption {
          type = with types; attrsOf path;
          default = { };
          description = ''
            Pre-made themes.
            Values should be a package or path containing the required files.
            Will be linked to {file}`$XDG_CONFIG_HOME/yazi/flavors/<name>.yazi`.

            See <https://yazi-rs.github.io/docs/flavors/overview/> for documentation.
          '';
          example = literalExpression ''
            {
              foo = ./foo;
              bar = pkgs.bar;
            }
          '';
        };

        theme = mkOption {
          inherit type default;
          example = literalExpression ''
            {
              filetype = {
                rules = [
                  { fg = "#7AD9E5"; mime = "image/*"; }
                  { fg = "#F3D398"; mime = "video/*"; }
                  { fg = "#F35A98"; mime = "audio/*"; }
                  { fg = "#CD9EFC"; mime = "application/bzip"; }
                ];
              };
            }
          '';
          description = ''
            Configuration written to
            {file}`$XDG_CONFIG_HOME/yazi/theme.toml`.

            See <https://yazi-rs.github.io/docs/configuration/theme>
            for the full list of options
          '';
        };

        settings = mkOption {
          default = { };
          description = ''
            Content of yazi.toml file.
            See the configuration reference at <https://yazi-rs.github.io/docs/configuration/yazi>
          '';

          type = types.submodule {
            freeformType = type;
            options = {
              mgr = mkMapOption ''
                Manager settings
                See <https://yazi-rs.github.io/docs/configuration/yazi#mgr>
              '';

              preview = mkMapOption ''
                Preview settings
                See <https://yazi-rs.github.io/docs/configuration/yazi#preview>
              '';

              opener = mkMapOption ''
                Opener settings
                See <https://yazi-rs.github.io/docs/configuration/yazi#opener>
              '';

              open = mkMapOption ''
                Open settings
                See <https://yazi-rs.github.io/docs/configuration/yazi#open>
              '';

              plugin = mkMapOption ''
                Plugin settings
                See <https://yazi-rs.github.io/docs/configuration/yazi#plugin>
              '';

              input = mkMapOption ''
                Input settings
                See <https://yazi-rs.github.io/docs/configuration/yazi#input>
              '';

              confirm = mkMapOption ''
                Confirm settings
                See <https://yazi-rs.github.io/docs/configuration/yazi#confirm>
              '';

              pick = mkMapOption ''
                Pick settings
                See <https://yazi-rs.github.io/docs/configuration/yazi#pick>
              '';

              which = mkMapOption ''
                Which settings
                See <https://yazi-rs.github.io/docs/configuration/yazi#which>
              '';

            };
          };
        };

        keymap = mkOption {
          default = { };
          description = ''
            Content of keymap.toml file.
            See the configuration reference at <https://yazi-rs.github.io/docs/configuration/keymap>
          '';

          type = types.submodule {
            freeformType = type;
            options = {
              mgr = mkMapOption ''
                Keymap mgr settings
                See <https://yazi-rs.github.io/docs/configuration/keymap#mgr>
              '';

              tasks = mkMapOption ''
                Keymap tasks settings
                See <https://yazi-rs.github.io/docs/configuration/keymap#tasks>
              '';

              spot = mkMapOption ''
                Keymap spot settings
                See <https://yazi-rs.github.io/docs/configuration/keymap#spot>
              '';

              pick = mkMapOption ''
                Keymap pick settings
                See <https://yazi-rs.github.io/docs/configuration/keymap#pick>
              '';

              input = mkMapOption ''
                Keymap input settings
                See <https://yazi-rs.github.io/docs/configuration/keymap#input>
              '';

              confirm = mkMapOption ''
                 Keymap confirm settings
                See < https://yazi-rs.github.io/docs/configuration/keymap#confirm>
              '';

              cmp = mkMapOption ''
                 Keymap cmp settings
                See < https://yazi-rs.github.io/docs/configuration/keymap#cmp>
              '';

              help = mkMapOption ''
                 Keymap help settings
                See < https://yazi-rs.github.io/docs/configuration/keymap#help>
              '';
            };
          };
        };
      };
    };
}
