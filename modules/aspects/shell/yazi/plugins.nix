{
  w.shell =
    { pkgs, lib, ... }:
    let
      inherit (lib) getExe;
      yazi-plugins-repo = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "plugins";
        rev = "442d9080da7524c8e58e10c610b832538c87464d";
        hash = "sha256-5WxCUf/Lv3wms7IPgkK0lJuJhIPa1E46obOFASS8eZU=";
      };

      yazi-fuzzy-search = pkgs.fetchFromGitHub {
        owner = "onelocked";
        repo = "fuzzy-search.yazi";
        rev = "16cea088a39c7769fbd22c4810347b04dd38c6b2";
        hash = "sha256-3YsZQ7SOkJZfUWP2KGzp8fPpT42M+x2aThs/AYmdy0o=";
      };

      fuzzy-search = pkgs.yaziPlugins.mkYaziPlugin {
        pname = "fuzzy-search.yazi";
        version = yazi-fuzzy-search.shortRev or yazi-fuzzy-search.dirtyShortRev or "dirty";
        src = lib.cleanSourceWith {
          src = yazi-fuzzy-search;
          filter = name: type: (baseNameOf name == "main.lua");
        };
      };

      zoom = yazi-plugins-repo + "/zoom.yazi";
    in
    {
      custom.programs.yazi.initLua = /* lua */ ''
        require("starship"):setup()

        require("git"):setup {
        	order = 1500, -- Order of status signs showing in the line mode
        }

        require("smart-enter"):setup {
          open_multi = true, -- Allow open to target multiple selected files
        }
      '';

      custom.programs.yazi.plugins = {
        inherit (pkgs.yaziPlugins)
          lazygit
          bypass
          git
          jump-to-char
          smart-filter
          smart-enter
          starship
          ouch
          restore
          piper
          chmod
          ;
        inherit zoom fuzzy-search;
      };

      custom.programs.yazi.settings = {
        plugin.prepend_previewers =
          let
            bat = "${getExe pkgs.bat} -p --color=always";
            qemu-img = lib.getExe' pkgs.qemu-utils "qemu-img";
          in
          with pkgs;
          [
            {
              url = "*.md";
              run = ''piper -- CLICOLOR_FORCE=1 ${getExe glow} -w=$w -s=dark -- "$1"'';
            }
            {
              mime = "text/*";
              run = ''piper -- ${bat} "$1"'';
            }
            {
              mime = "*/{xml,javascript,x-wine-extension-ini}";
              run = ''piper -- ${bat} "$1"'';
            }
            {
              url = "*.qcow2";
              run = ''piper -- ${qemu-img} info "$1" | ${bat} -l asa'';
            }
            {
              url = "*/";
              run = ''piper -- ${getExe eza} --color=always --icons=always --no-quotes -TL=3 "$1"'';
            }
            {
              url = "*.txt.gz";
              run = ''piper -- ${getExe gzip} -dc "$1"'';
            }
            {
              mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
              run = "ouch --show-file-icons";
            }
          ];

        plugin.append_previewers = [
          {
            url = "*";
            run = ''piper -- ${getExe pkgs.hexyl} --border=none --terminal-width=$w "$1"'';
          }
        ];

        plugin.prepend_fetchers = [
          {
            id = "git";
            url = "*";
            run = "git";
          }
          {
            id = "git";
            url = "*/";
            run = "git";
          }
        ];

      };
    };
}
