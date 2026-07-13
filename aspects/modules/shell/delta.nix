{
  exo.core =
    {
      birdee,
      config,
      scheme,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.delta;
    in
    {
      config = lib.mkMerge [
        { my.delta.enable = true; }

        (lib.mkIf (cfg.enable) {
          hj.packages = [ cfg.package ];
          programs.git.config.delta = cfg.settings;
        })
      ];

      options.my.delta = {
        enable = lib.mkEnableOption { };

        settings = lib.mkOption {
          type = lib.types.toml;
          default = { };
          description = "Options to go into delta's config section in gitconfig";
        };

        package = lib.mkOption {
          default = birdee.lib.wrapPackage {
            inherit pkgs;
            package = pkgs.delta;
            flagSeparator = "=";
            flags = with scheme.withHashtag; {
              "--dark" = true;
              "--diff-highlight" = true;
              "--line-numbers" = true;
              "--hyperlinks" = true;
              "--hyperlinks-file-link-format" = "lazygit-edit://{path}:{line}";
              "--line-fill-method" = "ansi";
              "--commit-style" = "${yellow}";
              "--file-style" = "${bright-red}";
              "--true-color" = "always";
              "--features" = "space-separated";
              "--paging" = "never";
            };
          };
        };
      };

      _file = ./delta.nix;

    };
}
