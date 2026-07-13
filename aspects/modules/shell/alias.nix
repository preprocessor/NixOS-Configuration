{
  exo.mods.desktop =
    {
      pkgs,
      config,
      lib,
      constants,
      ...
    }:
    let
      inherit (constants) cfgdir;
      _ = lib.getExe;
    in
    {
      hj.packages = [ pkgs.uutils-coreutils-noprefix ];

      environment.shellAliases = {
        shutdown = ''hyprshutdown -t "Shutting down..." --post-cmd "shutdown -P 0"'';
        reboot = ''hyprshutdown -t "Restarting..." --post-cmd "reboot"'';
      };

      programs.fish = {
        shellAliases = config.environment.shellAliases // {
          man = "batman";
          cat = "bat --plain ";

          gtop = _ pkgs.amdgpu_top;

          cp = "cp -r ";
          mkdir = "mkdir -p";

          rm = "trash-put ";
          rmdir = "trash-put ";
          delete = "rm";

          repl = "nix repl --file ${cfgdir}/repl.nix";

          ils = "mcat ls --hyprlink --kitty --ls-opts 'height=10%,items_per_row=6'";

          wf = "cd ${cfgdir} && nix run .#write-flake";
          ws = "cd ${cfgdir} && nix run .#write-sources";
        };

        shellAbbrs = {
          ehistory = ''nvim "${config.hj.xdg.data.directory}/fish/fish_history"'';
          ppath = "echo $PATH | tr ' ' '\n'";

          clone = "git clone";
          cls = "clear";

          ga = "git add .";
          gr = "cd (git rev-parse --show-toplevel)"; # cd to git root

          osto = "nh os test --offline";
          ost = "nh os test";
          rb = "nh os switch";

          v = "nvim";
          x = "exit";
        };

        functions = {
          mcd = "mkdir -p $argv[1]; and cd $argv[1]"; # mkdir + cd

          store = ''y (string match -r "/nix/store/[^/]*" (builtin realpath (type -fP $argv[1])))'';

          ncp = ''echo "pkgs.$(nurl $(wl-paste));" | wl-copy'';

          mem = ''
            echo "   PID Command                        PSS"
            , smem -c "pid command pss" -nkP $argv[1] | tail -n+3
          '';

          starship_transient_prompt_func = ''printf " \e[94m  \e[0m"'';

          __onelockeds_fuzzy_zox = /* fish */ ''
            set -l dir (
              zoxide query -ls 2>/dev/null \
              | awk -v home="$HOME" '{
                  score = $1
                  sub(/^[ \t]*[0-9.]+[ \t]+/, "", $0)
                  orig = $0
                  sub("^" home, "~", $0)

                  green = "\033[32m"
                  dim   = "\033[2m"
                  reset = "\033[0m"

                  printf "%s%6s %s│%s  %s\t%s\n", green, score, reset dim, reset, $0, orig
              }' \
              | fzf \
                  --ansi --no-sort --height=100% --layout=reverse --info=inline-right \
                  --scheme=path --delimiter='\t' --with-nth=1 \
                  --prompt "󰰷 Zoxide: ➜ " --pointer="▶" --separator "─" \
                  --scrollbar "│" --border="rounded" --padding="1,2" \
                  --header " Rank │  Directory" \
                  --preview '
                      printf "   Tree Structure\n";
                      printf "  \033[2m────────────────\033[0m\n";
                      eza -TL=3 --color=always --icons {2} 2>/dev/null | tail -n +2
                  ' \
                  --preview-window="right:50%:wrap:border-left" \
                  --bind "ctrl-j:down,ctrl-k:up" \
                  --bind "ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up" \
              | cut -f2 | string trim
            )

            if test -n "$dir"
                cd "$dir"
                # yazi
            end
            commandline -f repaint
          '';
        };
      };
    };
}
