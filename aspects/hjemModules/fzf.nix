{
  flake.hjemModules.fzf =
    {
      wrapPackage,
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.fzf;
      renderedColors =
        colors: colors |> lib.mapAttrsToList (name: value: "${name}:${value}") |> lib.join ",";
    in
    {
      options.my.fzf = {
        enable = lib.mkEnableOption "fzf";

        package = lib.mkPackageOption pkgs "fzf" { } // {

          default = wrapPackage {
            package = pkgs.fzf;
            env.FZF_DEFAULT_OPTS = lib.escapeShellArgs (
              cfg.defaultOptions ++ lib.optional (cfg.colors != { }) "--color=${renderedColors cfg.colors}"
            );
          };

        };

        defaultOptions = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        colors = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = { };
        };
      };

      config = lib.mkIf cfg.enable {
        hj.packages = [ cfg.package ];

        programs.fish.interactiveShellInit = /* fish */ ''
          ${lib.getExe cfg.package} --fish | source
        '';
      };

      _file = "fzf.nix";
    };
}
