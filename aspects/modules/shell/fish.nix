{ inputs, ... }:
{
  tack.inputs = {
    fish-completion-sync = {
      url = "gh:iynaix/fish-completion-sync";
      type = "fetch";
    };

    # my-nixpkgs = {
    #   url = "gh:preprocessor/nixpkgs/module-test";
    #   type = "fetch";
    # };
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
        description = ''
          A set of fish functions, with the attribute name being the function name. Function names cannot be reserved
          words or have spaces. These are elements of fish syntax or builtin commands which are essential for the
          operations of the shell. Current reserved words are [, _, and, argparse, begin, break, builtin, case,
          command, continue, else, end, eval, exec, for, function, if, not, or, read, return, set, status, string,
          switch, test, time, and while.

          See the documentation for [fish functions](https://fishshell.com/docs/current/cmds/function.html) for further information
        '';
        example = {
          ll.body = "ls -l $argv";
          mcd = {
            modifiers = ''--description "Create a directory and set CWD"'';
            body = ''
              command mkdir $argv
              if test $status = 0
                switch $argv[(count $argv)]
                  case '-*'

                  case '*'
                    cd $argv[(count $argv)]
                    return
                end
              end
            '';
          };
        };
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              body = lib.mkOption {
                type = lib.types.str;
                description = ''
                  The function body. You may provide a path or a string containing the fish function body.
                '';
              };

              modifiers = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = ''
                  Modifiers to be applied to the function. This is a string, concatenated with a space after the function nane
                '';
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
        };
    };

  exo.core =
    {
      # modulesPath,
      config,
      ...
    }:
    {
      # disabledModules = [ (modulesPath + "/programs/fish.nix") ];
      # imports = [ (inputs.my-nixpkgs + "/nixos/modules/programs/fish.nix") ];

      programs.fish = {
        enable = true;

        # shellFunctions."space test".body = "echo test";
        # shellFunctions."and".body = "echo test";

        shellInit = /* fish */ ''
          fish_vi_key_bindings # Vim mode

          set -g fish_greeting # Disable greeting

          set -g SHELL_PROGRAM fish

          # setup fish-completion-sync
          source ${inputs.fish-completion-sync}/init.fish

          bind Z __onelockeds_fuzzy_zox
          bind -M insert Z __onelockeds_fuzzy_zox
        '';

        extraCompletionPackages = config.hj.packages;
      };
    };
}
