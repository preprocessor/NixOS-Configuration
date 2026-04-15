{ lib, ... }:
{
  flake.modules.nixos.default =
    { pkgs, ... }:
    {
      programs = {
        fish.enable = true;
        bash.interactiveShellInit = /* bash */ ''
          # Auto start wayland session on tty1
          if [[ $(tty) == '/dev/tty1' ]]; then
            exec uwsm start niri-uwsm.desktop
          fi

          # Auto switch to fish while keeping bash as the system shell
          # See: https://fishshell.com/docs/current/index.html#default-shell
          PARENT_PROCESS=$(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm)
          if [[ # Only exec fish if:
            $PARENT_PROCESS != "fish" && # The parent process isn't already fish
            -z ''${BASH_EXECUTION_STRING} # Bash wasn't started in script mode (BASH_EXECUTION_STRING is empty)
          ]]; then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${lib.getExe pkgs.fish} $LOGIN_OPTION
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
