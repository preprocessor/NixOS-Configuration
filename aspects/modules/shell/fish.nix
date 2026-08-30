{
  tack.inputs.fish-completion-sync = {
    url = "gh:iynaix/fish-completion-sync";
    type = "fetch";
  };

  exo.skeleton =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      options.programs.fish.shellFunctions = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              body = lib.mkOption {
                type = lib.types.str;
              };

              modifiers = lib.mkOption {
                type = lib.types.str;
                default = "";
              };
            };

          }
        );
      };

      config =
        let
          cfg = config.programs.fish;

          indentFishFile =
            name: text:
            pkgs.runCommandLocal name {
              nativeBuildInputs = [ cfg.package ];
              inherit text;
              passAsFile = [ "text" ];
            } "fish --no-config -c 'fish_indent $textPath' > $out";
        in
        {
          environment.etc = lib.mapAttrs' (name: value: {
            name = "fish/functions/${name}.fish";
            value.source = indentFishFile "${name}.fish" ''
              function ${name} ${value.modifiers}
                ${lib.trim value.body}
              end
            '';
          }) cfg.shellFunctions;

          programs.fish.shellInit = ''
            # Add the search path for global fish functions
            set fish_function_path /etc/fish/functions/ $fish_function_path
          '';
        };
    };

  exo.core =
    {
      inputs,
      config,
      ...
    }:
    {
      programs.fish = {
        enable = true;
        extraCompletionPackages = config.hj.packages;

        shellInit = /* fish */ ''
          fish_vi_key_bindings # Vim mode

          set -g fish_greeting # Disable greeting

          set -g SHELL_PROGRAM fish

          # setup fish-completion-sync
          source ${inputs.fish-completion-sync}/init.fish

          bind Z __onelockeds_fuzzy_zox
          bind -M insert Z __onelockeds_fuzzy_zox
        '';

      };
    };
}
