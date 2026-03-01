{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    preferAbbrs = true;

    functions = {
      fish_greeting = "";

      starship_transient_prompt_func = ''echo -e " \e[1;32m  \e[0m"'';

      mcd = "mkdir -p $argv[1]; and cd $argv[1]";
    };

    shellAliases = {
      rebuild = "nh os switch --diff always";
      repl = "nix repl --file ~/Configuration/NixOS/repl.nix";

      ls = "eza --group-directories-first --icons";
      la = "eza --group-directories-first --icons -a";
      ll = "eza --group-directories-first --icons -al";

      cp = "cp -r";
      mkdir = "mkdir -p";

      rm = "rmtrash -r";
      rmdir = "rmdirtrash";
    };

    shellAbbrs = {
      cls = "clear";

      v = "nvim";

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
}
