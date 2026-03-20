{
  flake.modules.nixos.default.programs.fish.enable = true;

  flake.modules.homeManager.default =
    { pkgs, ... }:
    {
      programs.fish = {
        enable = true;
        preferAbbrs = true;

        functions = {
          fish_greeting = "";

          starship_transient_prompt_func = ''echo -e " \e[1;32m  \e[0m"'';

          mcd = "mkdir -p $argv[1]; and cd $argv[1]"; # mkdir + cd
          gr = "cd (git rev-parse --show-toplevel)"; # cd to git root

          __zoxide_interactive = # fish
            ''
              set dir (zoxide query --interactive | string trim)

              if test -n "$dir"
                cd "$dir"
                y
              end

              commandline -f repaint
            '';
        };

        interactiveShellInit = ''
          bind Z __zoxide_interactive
        '';

        shellAliases = {
          rebuild = "nh os switch --diff always";
          repl = "nix repl --file ~/Configuration/NixOS/repl.nix";

          ls = "eza --group-directories-first --icons";
          la = "eza --group-directories-first --icons -a";
          ll = "eza --group-directories-first --icons -al";

          man = "batman";

          cp = "cp -r";
          mkdir = "mkdir -p";

          rm = "trash-put";
          rmdir = "trash-put";

          # "" = "nvim ";
        };

        shellAbbrs = {
          cls = "clear";

          v = "nvim";
          # v = "";

          rustrepl = "evcxr";

          clone = "git clone";
        };

        plugins = with pkgs.fishPlugins; [
          {
            name = "fzf";
            src = fzf.src;
          }
          {
            name = "enhancd";
            src = pkgs.fetchFromGitHub {
              owner = "babarot";
              repo = "enhancd";
              rev = "v2.5.1";
              hash = "sha256-kaintLXSfLH7zdLtcoZfVNobCJCap0S/Ldq85wd3krI=";
            };
          }
        ];
      };
    };
}
