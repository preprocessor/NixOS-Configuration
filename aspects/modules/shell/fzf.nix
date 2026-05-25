{
  w.desktop =
    { scheme, ... }:
    {
      custom.programs.fzf = {
        enable = true;
        colors = with scheme.withHashtag; {
          "bg+" = base02; # selection background
          "fg+" = base07; # current item text
          "hl" = base0B; # match chars, unselected
          "hl+" = base0B; # match chars, selected
          "info" = base0D; # match count
          "prompt" = base0E; # ❯ prompt
          "pointer" = base0F; # ▶ current line marker
          "marker" = base14; # ● multi-select tick
          "spinner" = base0A; # loading indicator
          "header" = base15; # --header string
          "border" = base02; # border lines
          "gutter" = base00; # gutter bg
        };
        defaultOptions = [
          "--layout=reverse"
          "--border=sharp"
          "--preview-window=sharp"
          "--padding=0,1"
          "--prompt=  "
          "--pointer= "
          "--marker=✓ "
          "--info=inline"
          "--scrollbar=▓"
          "--cycle"
        ];
      };
    };

  w.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.custom.programs.fzf;
      renderedColors =
        colors: colors |> lib.mapAttrsToList (name: value: "${name}:${value}") |> lib.concatStringsSep ",";
    in
    {
      options.custom.programs.fzf = {
        enable = lib.mkEnableOption "fzf";
        package = lib.mkPackageOption pkgs "fzf" { };
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
        hj.environment.sessionVariables = {
          FZF_DEFAULT_OPTS = lib.escapeShellArgs (
            cfg.defaultOptions ++ lib.optional (cfg.colors != { }) "--color=${renderedColors cfg.colors}"
          );
        };

        programs.fish.interactiveShellInit = /* fish */ ''
          ${lib.getExe cfg.package} --fish | source
        '';
      };

      _file = ./fzf.nix;
    };

}
