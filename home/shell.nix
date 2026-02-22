{ lib, config, pkgs, ... }:
{
  programs = {
    fish = {
      enable = true;
      preferAbbrs = true;

      functions = {
        fish_greeting = "";

        mcd = "mkdir -p $argv[1]; and cd $argv[1]";

        envtemplate = lib.concatStrings [
          "nix flake init --template 'https://flakehub.com/f/the-nix-way/dev-templates/*#$argv[1]'"
          "direnv allow"
        ];
      };

      shellAliases = {
        weather = "curl -s 'wttr.in/?A&0'";

        rebuild = "nh os switch --diff always";
        repl = "nix repl --file ~/Configuration/NixOs/repl.nix";

        ls = "eza --group-directories-first --icons";
        la = "eza --group-directories-first --icons -a";
        ll = "eza --group-directories-first --icons -al";

        cp = "cp -r";

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
          name = "fish-async-prompt";
          src = async-prompt.src;
        }
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
        {
          name = "gitnow";
          src = pkgs.fetchFromGitHub {
            owner = "joseluisq";
            repo = "gitnow";
            rev = "2.13.0";
            hash = "sha256-F0dTu/4XNvmDfxLRJ+dbkmhB3a8aLmbHuI3Yq2XmxoI=";
          };
        }
        {
          name = "magic-enter";
          src = pkgs.fetchFromGitHub {
            owner = "mattmc3";
            repo = "magic-enter.fish";
            rev = "ddcf5c2cf9ff90c15a724bcdd794a486098492e0";
            hash = "sha256-zDrc2d2VTeTiukRLeezlbj06ICr0AJId/iJx11xPKyo=";
          };
        }
      ];
    };

    starship = {
      enable =  true;
      enableInteractive = false;
      enableFishIntegration = true;
      enableBashIntegration = true;

      settings = {
        add_newline = false;

        right_format = "$nix_shell";

        format = lib.concatStrings [
          "[](fg:blue)"
          "$directory"
          "[](fg:blue)"
          "$git_branch"
          "$character"
        ];

        nix_shell = {
          format = "[ nix-shell](cyan)";
        };

        character = {
          success_symbol = " [](green) ";
          error_symbol = " [](red) ";
        };

        directory = {
          # style = "fg:#f5a97f bg:blue bold";
          style = "fg:black bg:blue bold";
          format = "[$path]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
          home_symbol = "🐸";
        };

        directory.substitutions = {
          ".config" =" ";
          "nvim" = " ";
        };

        git_branch = {
          symbol = "";
          format = " [ $symbol $branch ](fg:blue bold)";
        };

        git_status = {
          format = "[($all_status$ahead_behind )](fg:blue bold)";
        };
      };
    };


    nix-your-shell = {
      enable = true;
      enableFishIntegration = true;
    };

    # zsh = {
    #   enable = false;
    #   dirHashes = {
    #     docs   = "${config.home.homeDirectory}/Documents";
    #     vids   = "${config.home.homeDirectory}/Videos";
    #     dl     = "${config.home.homeDirectory}/Downloads";
    #     code   = "${config.home.homeDirectory}/Code";
    #     nixcfg = "${config.home.homeDirectory}/Configuration";
    #     config = "${config.home.homeDirectory}/.config";
    #   };
    #
    #   initContent = ''
    #     # pass -h and --help through bat
    #     alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
    #     alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
    #   '';
    # };

    lazygit = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;

      settings = {
        git.pagers = [
          { pager = ''delta --file-style "#74548c" --features space-separated --dark --diff-highlight --true-color always --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}" --line-fill-method=ansi --navigate --keep-plus-minus-markers --commit-style="#8eb893"''; }
          { pager = ''delta --side-by-side --file-style "#74548c" --features space-separated --dark --diff-highlight --true-color always --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}" --line-fill-method=ansi --navigate --keep-plus-minus-markers --commit-style="#8eb893"''; }
        ];
      };
    };

    atuin = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;

      settings = {
        filter_mode = "directory";
        enter_accept = true;
      };
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };

    yazi = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };


  };
}
