{
  w.desktop =
    { config, lib, ... }:
    {
      hj.xdg.mime-apps.default-applications =
        [
          "audio/aac"
          "audio/mpeg"
          "audio/ogg"
          "audio/opus"
          "audio/wav"
          "audio/webm"
          "audio/x-matroska"
          "video/mp2t"
          "video/mp4"
          "video/mpeg"
          "video/ogg"
          "video/webm"
          "video/x-flv"
          "video/x-matroska"
          "video/x-msvideo"
        ]
        |> map (mime: lib.nameValuePair mime [ "mpv.desktop" ])
        |> lib.listToAttrs;

      my.hyprland.lua.files."window_rules.mpv".content = /* lua */ ''
        hl.window_rule({
          name         = "mpv",
          match        = { class = "mpv" },
          center       = true,
          float        = true,
        })
      '';

      my.mpv = {
        enable = true;

        conf = # ini
          ''
            osd-duration=500
            osc=no
            video-sync=display-resample
            interpolation=yes
            volume=100
            ao=pipewire
            audio-buffer=0.1
            audio-file-auto=fuzzy
            sub-auto=fuzzy
            sub-font="Apple Color Emoji"
            gpu-context=auto
            hwdec=auto-copy
            profile=gpu-hq
            vo=gpu-next
            gpu-api=auto
            deband=yes
            wayland-edge-pixels-pointer=0
            wayland-edge-pixels-touch=0
            screenshot-format=webp
            screenshot-webp-lossless=yes
            screenshot-directory=${config.hj.directory}/Pictures/Screenshots/mpv
            screenshot-sw=yes
            input-default-bindings=yes
            ytdl-format=bestvideo[height<=2160]+bestaudio/best[height<=2160]
            autofit=x1355
          '';
        input = # bash
          ''
            MBTN_LEFT cycle pause
            WHEEL_DOWN add volume -1
            WHEEL_UP add volume 1
            S screenshot video

            h no-osd seek -5 exact
            LEFT no-osd seek -5 exact
            l no-osd seek 5 exact
            RIGHT no-osd seek 5 exact
            j seek -30
            DOWN seek -30
            k seek 30
            UP seek 30

            H no-osd seek -1 exact
            Shift+LEFT no-osd seek -1 exact
            L no-osd seek 1 exact
            Shift+RIGHT no-osd seek 1 exact
            J seek -300
            Shift+DOWN seek -300
            K seek 300
            Shift+UP seek 300

            Ctrl+LEFT no-osd sub-seek -1
            Ctrl+h no-osd sub-seek -1
            Ctrl+RIGHT no-osd sub-seek 1
            Ctrl+l no-osd sub-seek 1
            Ctrl+DOWN add chapter -1
            Ctrl+j add chapter -1
            Ctrl+UP add chapter 1
            Ctrl+k add chapter 1

            Alt+LEFT frame-back-step
            Alt+h frame-back-step
            Alt+RIGHT frame-step
            Alt+l frame-step

            PGUP add chapter 1
            PGDWN add chapter -1

            u revert-seek

            Ctrl++ add sub-scale 0.1
            Ctrl+- add sub-scale -0.1
            Ctrl+0 set sub-scale 0

            q quit
            Q quit-watch-later
            q {encode} quit 4
            p cycle pause
            SPACE cycle pause
            f cycle fullscreen

            n playlist-next
            N playlist-prev

            o show-progress
            O script-binding stats/display-stats-toggle

            s cycle sub
            v cycle video
            a cycle audio
            c add panscan 0.1
            PLAY cycle pause
            PAUSE cycle pause
            PLAYPAUSE cycle pause
            PLAYONLY set pause no
            PAUSEONLY set pause yes
            STOP stop
          '';
      };
    };
}
