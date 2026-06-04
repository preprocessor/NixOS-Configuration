{
  w.shell =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      inherit (lib) getExe;
    in
    {
      wrappers.yazi.plugins = {
        inherit (pkgs.yaziPlugins) piper;
      };

      wrappers.yazi.settings = {
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
              run = ''piper -- ${getExe config.wrappers.eza.package} --color=always --icons=always --no-quotes -TL=3 -l --git --no-permissions --no-user --group-directories-first --no-filesize --no-time "$1"/'';
            }
            {
              url = "*.txt.gz";
              run = ''piper -- ${getExe gzip} -dc "$1"'';
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
