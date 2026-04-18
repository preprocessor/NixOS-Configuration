{ inputs, ... }:
{
  flake.modules.nixos.shell =
    { pkgs, lib, ... }:
    let
      inherit (lib) getExe;
      zoom = inputs.yazi-plugins-repo + "/zoom.yazi";
      fuzzy-search = inputs.yazi-plugin-fuzzy-search.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      custom.programs.yazi.settings = {
        plugins = {
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

      };
    };
}
