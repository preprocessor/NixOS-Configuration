{
  modules.features.desktop = { config, self, ... }: {
    imports = [ self.hjemModules.mpv ];

    my.mpvi = {
      enable = true;

      conf = {
        image-display-duration = "inf";
        loop-file = "inf";
        autofit = "x1200";
        osd-level = 0;
        window-dragging = false;
        osc = false;
        gpu-context = "auto";
        hwdec = "auto-copy";
        profile = "gpu-hq";
        vo = "gpu-next";
        gpu-api = "auto";
      };

      input = {
        "MBTN_LEFT" = "script-binding positioning/drag-to-pan";
        "WHEEL_UP" = "add video-zoom  0.1";
        "WHEEL_DOWN" = "add video-zoom -0.1";

        "k" = "add video-pan-y  0.01";
        "j" = "add video-pan-y -0.01";
        "h" = "add video-pan-x  0.01";
        "l" = "add video-pan-x -0.01";

        "Ctrl+r" = "set video-zoom 0 ; set video-pan-x 0 ; set video-pan-y 0";
      };
    };

    my.mpv = {
      enable = true;

      conf = {
        osd-duration = 500;
        osc = false;
        video-sync = "display-resample";
        interpolation = true;
        volume = 100;
        ao = "pipewire";
        audio-buffer = 0.1;
        audio-file-auto = "fuzzy";
        sub-auto = "fuzzy";
        sub-font = ''"Apple Color Emoji"'';
        gpu-context = "auto";
        hwdec = "auto-copy";
        profile = "gpu-hq";
        vo = "gpu-next";
        gpu-api = "auto";
        deband = true;
        wayland-edge-pixels-pointer = 0;
        wayland-edge-pixels-touch = 0;
        screenshot-format = "webp";
        screenshot-webp-lossless = true;
        screenshot-directory = "${config.hj.directory}/Pictures/Screenshots/mpv";
        screenshot-sw = true;
        input-default-bindings = true;
        ytdl-format = "bestvideo[height<=2160]+bestaudio/best[height<=2160]";
        autofit = "x1355";
      };

      input = {
        "MBTN_LEFT" = "cycle pause";
        "WHEEL_DOWN" = "add volume -1";
        "WHEEL_UP" = "add volume 1";
        "S" = "screenshot video";

        "h" = "no-osd seek -5 exact";
        "LEFT" = "no-osd seek -5 exact";
        "l" = "no-osd seek 5 exact";
        "RIGHT" = "no-osd seek 5 exact";
        "j" = "seek -30";
        "DOWN" = "seek -30";
        "k" = "seek 30";
        "UP" = "seek 30";

        "H" = "no-osd seek -1 exact";
        "Shift+LEFT" = "no-osd seek -1 exact";
        "L" = "no-osd seek 1 exact";
        "Shift+RIGHT" = "no-osd seek 1 exact";
        "J" = "seek -300";
        "Shift+DOWN" = "seek -300";
        "K" = "seek 300";
        "Shift+UP" = "seek 300";

        "Ctrl+LEFT" = "no-osd sub-seek -1";
        "Ctrl+h" = "no-osd sub-seek -1";
        "Ctrl+RIGHT" = "no-osd sub-seek 1";
        "Ctrl+l" = "no-osd sub-seek 1";
        "Ctrl+DOWN" = "add chapter -1";
        "Ctrl+j" = "add chapter -1";
        "Ctrl+UP" = "add chapter 1";
        "Ctrl+k" = "add chapter 1";

        "Alt+LEFT" = "frame-back-step";
        "Alt+h" = "frame-back-step";
        "Alt+RIGHT" = "frame-step";
        "Alt+l" = "frame-step";

        "PGUP" = "add chapter 1";
        "PGDWN" = "add chapter -1";

        "u" = "revert-seek";

        "Ctrl++" = "add sub-scale 0.1";
        "Ctrl+-" = "add sub-scale -0.1";
        "Ctrl+0" = "set sub-scale 0";

        "q" = [
          "quit"
          "{encode} quit 4"
        ];

        "Q" = "quit-watch-later";
        "p" = "cycle pause";
        "SPACE" = "cycle pause";
        "f" = "cycle fullscreen";

        "n" = "playlist-next";
        "N" = "playlist-prev";

        "o" = "show-progress";
        "O" = "script-binding stats/display-stats-toggle";

        "s" = "cycle sub";
        "v" = "cycle video";
        "a" = "cycle audio";
        "c" = "add panscan 0.1";
        "PLAY" = "cycle pause";
        "PAUSE" = "cycle pause";
        "PLAYPAUSE" = "cycle pause";
        "PLAYONLY" = "set pause no";
        "PAUSEONLY" = "set pause yes";
        "STOP" = "stop";
      };
    };
  };
}
