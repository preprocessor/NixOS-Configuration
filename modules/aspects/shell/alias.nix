{ self, ... }:
{

  w.default =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      hj.packages = [ pkgs.uutils-coreutils-noprefix ];

      programs.fish = {
        shellAliases =
          let
            lla = lib.getExe pkgs.lla;
          in
          config.environment.shellAliases
          // {
            l = lla + " -T ";
            ls = lla;
            la = lla + " -AT ";
            ll = lla + " -Al ";
            lss = lla + " -S ";

            man = "batman";
            cat = "bat --plain ";

            gtop = lib.getExe pkgs.amdgpu_top;

            cp = "cp -r ";
            mkdir = "mkdir -p";

            rm = "trash-put ";
            rmdir = "trash-put ";

            repl = "nix repl --file ${self.const.cfgdir}/repl.nix";
          };

        shellAbbrs = {
          ehistory = ''nvim "${config.hj.xdg.data.directory}/fish/fish_history"'';
          ppath = "echo $PATH | tr ' ' '\n'";

          nos = "cd /home/wyspr/Configuration/NixOS/ && yazi";

          clone = "git clone";
          cls = "clear";

          ga = "git add .";
          gr = "cd (git rev-parse --show-toplevel)"; # cd to git root

          ost = "nh os test";
          rb = "nh os switch";
          wf = "cd ${self.const.cfgdir} && nix run .#write-flake";

          v = "nvim";
          x = "exit";
        };

        functions = {
          mcd = "mkdir -p $argv[1]; and cd $argv[1]"; # mkdir + cd

          store = ''y (string match -r "/nix/store/[^/]*" (builtin realpath (type -fP yazi)))'';

          ncp = ''echo "pkgs.$(nurl $(wl-paste));" | wl-copy'';

          starship_transient_prompt_func = ''printf " \e[1;96m  \e[0m"'';

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
