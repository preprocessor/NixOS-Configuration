{
  tack.yazi.url = "gh:sxyazi/yazi";

  w.default =
    {
      pkgs,
      lib,
      config,
      birdee,
      packages',
      ...
    }:
    let
      mkMapOption =
        description:
        lib.mkOption {
          inherit description;
          inherit (toml) type;
          default = { };
        };

      toml = pkgs.formats.toml { };
      cfg = config.my.yazi;
    in
    with lib;
    {
      config = mkIf (cfg.enable) {
        my.xdg.desktopEntries."yazi".noDisplay = true;

        utils.yaziKeymap = on: run: desc: { inherit on run desc; };

        hj.packages = [ cfg.package ];

        programs.fish.functions.y = /* fish */ ''
          set -l tmp (mktemp -t "yazi-cwd.XXXXX")
          command yazi $argv --cwd-file="$tmp"
          if read cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
          end
          rm -f -- "$tmp"
        '';
      };

      options.my.yazi = {
        package = mkOption {
          type = types.package;
          default = birdee.wrappers.yazi.wrap {
            inherit pkgs;
            inherit (cfg) plugins;
            package = packages'.yazi;
            runtimePkgs = with pkgs; [
              ouch-rar
              ripgrep
              unrar
              unzip
              glow
              git
            ];
            settings = {
              inherit (cfg) keymap theme;
              yazi = cfg.settings;
            };
            constructFiles = {
              initLua = {
                relPath = "yazi-config/init.lua";
                content = cfg.initLua;
              };

              flavor = {
                relPath = "yazi-config/flavors/wyspr.yazi/flavor.toml";
                content = cfg.flavorContent;
              };
            };
          };
        };

        enable = lib.mkEnableOption { };

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

        theme = lib.mkOption {
          inherit (toml) type;
          default = { };
          description = "Theme settings";
        };

        flavorContent = lib.mkOption {
          type = with lib.types; nullOr lines;
          default = "";
          description = "Raw TOML content for the flavor file";
        };

        settings = mkOption {
          default = { };
          description = ''
            Content of yazi.toml file.
            See the configuration reference at <https://yazi-rs.github.io/docs/configuration/yazi>
          '';

          type = types.submodule {
            freeformType = toml.type;
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
            freeformType = toml.type;
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

      _file = ./module.nix;
    };
}
