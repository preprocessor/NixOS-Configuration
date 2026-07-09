{
  w.desktop =
    { config, lib, ... }:
    {

      hj.xdg.mime-apps.default-applications =
        [
          "image/bmp"
          "image/gif"
          "image/jpeg"
          "image/jpg"
          "image/png"
          "image/tiff"
          "image/vnd.microsoft.icon"
          "image/webp"
        ]
        |> map (mime: lib.nameValuePair mime [ "mpvi.desktop" ])
        |> lib.listToAttrs;

      custom.programs.mpv = {
        image-conf = # ini
          ''
            image-display-duration=inf
            loop-file=inf
            autofit=x1200
            osd-level=0
            window-dragging=no
            osc=no
            gpu-context=auto
            hwdec=auto-copy
            profile=gpu-hq
            vo=gpu-next
            gpu-api=auto
          '';

        image-input = ''
          MBTN_LEFT script-binding positioning/drag-to-pan
          WHEEL_UP      add video-zoom  0.1
          WHEEL_DOWN    add video-zoom -0.1

          k             add video-pan-y  0.01
          j             add video-pan-y -0.01
          h             add video-pan-x  0.01
          l             add video-pan-x -0.01

          Ctrl+r         set video-zoom 0 ; set video-pan-x 0 ; set video-pan-y 0
        '';

      };
    };
}
