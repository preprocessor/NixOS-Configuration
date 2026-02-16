{ lib, config, pkgs, ... }:
{
  programs = {
    fish = {
      enable = true;
      preferAbbrs = true;

      functions = {
        fish_greeting = "";

        mcd = "mkdir -p $argv[1]; and cd $argv[1]";
      };

      shellAliases = {
        weather = "curl -s 'wttr.in/?A&0'";

        rebuild = "nh os build --diff always";
        repl = "nix repl --file ~/Configuration/repl.nix";

        ls = "eza --group-directories-first --icons";
        la = "eza --group-directories-first --icons -a";
        ll = "eza --group-directories-first --icons -al";

        cp="cp -r";

        rm="rmtrash -r";
        rmdir="rmdirtrash";
      };

      shellAbbrs = {
        cls="clear";

        nv="nvim";

        tree="tre ";

        rust="evcxr";
        c="cargo";

        clone="git clone";
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

    nix-your-shell = {
      enable = true;
      enableFishIntegration = true;
    };

    zsh = {
      enable = false;
      dotDir = "${config.xdg.configHome}/zsh";

      autocd = true;

      enableCompletion = true;
      autosuggestion = {
        enable = true;
        highlight = "fg=yellow,underline";
        strategy = [
          "history"
          "completion"
        ];
      };

      # Whether to enable integration with terminals using the VTE library. This will let the terminal track the current working directory.
      enableVteIntegration = true;

      setOptions = [
        "EXTENDED_HISTORY"
        "CORRECT"
        "NO_NOTIFY"
      ];

      dirHashes = {
        docs   = "${config.home.homeDirectory}/Documents";
        vids   = "${config.home.homeDirectory}/Videos";
        dl     = "${config.home.homeDirectory}/Downloads";
        code   = "${config.home.homeDirectory}/Code";
        nixcfg = "${config.home.homeDirectory}/Configuration";
        config = "${config.home.homeDirectory}/.config";
      };

      antidote = {
        enable = true;
        useFriendlyNames = true;
        plugins = [
          "zsh-users/zsh-autosuggestions"
          "Aloxaf/fzf-tab"
          "Freed-Wu/fzf-tab-source"
          "chrissicool/zsh-256color"
          "zsh-users/zsh-completions"
          "le0me55i/zsh-extract"

          # file extension color mappings
          # znap eval trapd00r/LS_COLORS "$( whence -a dircolors gdircolors ) -b LS_COLORS"
          # use LS_COLORS to theme less, git, grep and others
          # znap source marlonrichert/zcolors
          # znap eval   marlonrichert/zcolors "zcolors ${(q)LS_COLORS}"
          # fish-like syntax highlighting
          "zsh-users/zsh-syntax-highlighting"
        ];
      };

      history = {
        append = true;
        expireDuplicatesFirst = true;

        # If a new command line being added to the history list duplicates an older one,
        # the older command is removed from the list (even if it is not the previous event).
        ignoreAllDups = true;

        # Do not enter comm and lines into the history list if the first character is a space.
        ignoreSpace = true;

        # Do not display a line previously found in the history file.
        findNoDups = true;

        # Do not write duplicate entries into the history file.
        saveNoDups = true;

        # Share command history between zsh sessions.
        share = true;
      };

      shellAliases = {
      };


      initContent = ''

        unset REPORTTIME

        ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )
        ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(buffer-empty bracketed-paste accept-line push-line-or-edit)

        # function dotgit {
        #   git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
        # }

        # mcd: make and change dir
        mcd() {
            mkdir -p "$1"
            cd "$1"
        }

        # pass -h and --help through bat
        alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
        alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

        #  ╭─────────────────╮
        #  │ zsh completions │
        #  ╰─────────────────╯
        #  ╭─────────╮
        #  │ fzf-tab │
        #  ╰─────────╯

        #  ╭──────────╮
        #  │ keybinds │
        #  ╰──────────╯

      '';
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;

        format = lib.concatStrings [
          "[](fg:blue)"
          "$directory"
          "[](fg:blue)"
          "$git_branch"
          "$character"
        ];

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
          ".config" = "⚙️";
          "Documents" = "📄";
          "Downloads" = "👇";
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
