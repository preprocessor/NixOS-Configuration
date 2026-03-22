{ inputs, ... }:
{
  flake-file.inputs.fish-plugin-enhancd = {
    url = "github:babarot/enhancd";
    flake = false;
  };

  flake.modules.nixos.default =
    { pkgs, ... }:
    {
      programs = {
        fish.enable = true;
        bash.interactiveShellInit = ''
          if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
          then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
          fi
        '';
      };
    };

  flake.modules.homeManager.default =
    { pkgs, ... }:
    {
      programs.fish = {
        enable = true;
        preferAbbrs = true;

        functions = {
          starship_transient_prompt_func = ''printf  " \e[1;96m  \e[0m"'';

          mcd = "mkdir -p $argv[1]; and cd $argv[1]"; # mkdir + cd

          __zoxide_interactive = /* fish */ ''
            set dir (zoxide query --interactive | string trim)

            if test -n "$dir"
              cd "$dir"
            end

            commandline -f repaint
          '';
        };

        interactiveShellInit = /* fish */ ''
          fish_vi_key_bindings # Vim mode

          bind -M insert Z __zoxide_interactive

          set -g fish_greeting # Disable greeting
        '';

        plugins = with pkgs.fishPlugins; [
          {
            name = "fzf";
            src = fzf.src;
          }
          {
            name = "enhancd";
            src = inputs.fish-plugin-enhancd;
          }
        ];
      };
    };
}
