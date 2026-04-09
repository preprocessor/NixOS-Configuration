{ inputs, ... }:
{
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
        };

        interactiveShellInit = /* fish */ ''
          fish_vi_key_bindings # Vim mode

          set -g fish_greeting # Disable greeting
        '';

        plugins = with pkgs.fishPlugins; [
          {
            name = "fzf";
            src = fzf.src;
          }
        ];
      };
    };
}
