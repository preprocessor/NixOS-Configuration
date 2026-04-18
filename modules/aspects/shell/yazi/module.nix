{ inputs, ... }:
{
  flake-file.inputs = {
    yazi-plugin-fuzzy-search.url = "github:onelocked/fuzzy-search.yazi";
    yazi-plugins-repo = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
  };

  flake.modules.nixos.shell =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      environment.systemPackages = [
        (inputs.wrappers.wrappers.yazi.wrap {
          inherit pkgs;
          extraPackages = with pkgs; [
            glow
            ripgrep
            ouch
          ];
          settings = with config.custom.programs; {
            keymap = yazi.keymap;
            yazi = yazi.settings;
          };
        })
      ];

      hj.packages = [ pkgs.ouch ];

      hj.xdg.config.files."yazi/init.lua".text = /* lua */ ''
        require("starship"):setup()

        require("git"):setup {
        	order = 1500, -- Order of status signs showing in the line mode
        }

        require("smart-enter"):setup {
          open_multi = true, -- Allow open to target multiple selected files
        }
      '';

      programs.fish.functions.y = /* fish */ ''
        set -l tmp (mktemp -t "yazi-cwd.XXXXX")
        command yazi $argv --cwd-file="$tmp"
        if read cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
          builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
      '';
    };

  flake.modules.nixos.default =
    { pkgs, lib, ... }:
    let
      inherit (pkgs.formats.toml { }) type;
      default = { };
      mkMapOption = description: lib.mkOption { inherit type description default; };
    in
    {
      options.custom.programs.yazi = {
        settings = lib.mkOption {
          default = { };

          description = ''
            Content of yazi.toml file.
            See the configuration reference at <https://yazi-rs.github.io/docs/configuration/yazi>
          '';

          type = lib.types.submodule {
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

        keymap = lib.mkOption {
          default = { };
          description = ''
            Content of keymap.toml file.
            See the configuration reference at <https://yazi-rs.github.io/docs/configuration/keymap>
          '';

          type = lib.types.submodule {
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
