{
  w.shell =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.bash.interactiveShellInit = /* bash */ ''
        # Auto start wayland session on tty1
        if [[ $(tty) == '/dev/tty1' ]]; then
          # exec uwsm start niri-uwsm.desktop
          ${lib.getExe' config.programs.hyprland.package "start-hyprland"}
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
}
