{ lib, ... }:
{
  flake.modules.homeManager.default =
    { pkgs, ... }:
    {
      programs.yazi = {
        enable = true;
        shellWrapperName = "y";
        enableBashIntegration = true;
        enableFishIntegration = true;

        settings.open = {
          prepend_rules = [
            {
              mime = "image/*"; # Apply this to all image types
              use = [
                "open"
                "setwallpaper"
                "gimp"
              ];
            }
            {
              mime = "video/*"; # Apply this to all video types
              use = [
                "open"
                "setwallpaper"
              ];
            }
            {
              mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
              use = [ "ouch" ];
            }
          ];
        };

        settings.opener =
          with pkgs;
          with lib;
          {
            setwallpaper = [
              {
                run = "${getExe' awww "awww"} img --transition-fps 75 %s";
                desc = "Set Wallpaper";
              }
            ];
            gimp = [
              {
                run = "${getExe gimp} %s";
                desc = "Image Editor";
              }
            ];
            video-trimmer = [
              {
                run = "${getExe video-trimmer} %s";
                desc = "Video Trimmer";
              }
            ];
            ouch = [
              {
                run = ''${getExe ouch} d -y "$@"'';
                desc = "Extract here with ouch";
              }
            ];
          };

        settings.preview = {
          wrap = "no";
          tab_size = 2;
          image_filter = "triangle"; # from fast to slow but high quality: nearest, triangle, catmull-rom, lanczos3
          cache_dir = "";
          image_delay = 0;
          max_width = 1926;
          max_height = 1366;
          image_quality = 90;
        };

        settings.mgr = {
          ratio = [
            1
            2
            4
          ];
        };
      };
    };
}
