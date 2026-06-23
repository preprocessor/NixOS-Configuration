{
  w.ramiel =
    { lib, ... }:
    with lib;
    let
      defaultApps = {
        text = [ "nvim.desktop" ];
        image = [ "mpv.desktop" ];
        audio = [ "mpv.desktop" ];
        video = [ "mpv.desktop" ];
        directory = [ "kitty.desktop" ];
        terminal = [ "kitty.desktop" ];
        browser = [ "vivaldi-stable.desktop" ];
      };

      mimeMap = {
        text = [
          "text/plain"
          "text/x-python"
          "text/x-shellscript"
        ];
        image = [
          "image/bmp"
          "image/gif"
          "image/jpeg"
          "image/jpg"
          "image/png"
          "image/svg+xml"
          "image/tiff"
          "image/vnd.microsoft.icon"
          "image/webp"
        ];
        audio = [
          "audio/aac"
          "audio/mpeg"
          "audio/ogg"
          "audio/opus"
          "audio/wav"
          "audio/webm"
          "audio/x-matroska"
        ];
        video = [
          "video/mp2t"
          "video/mp4"
          "video/mpeg"
          "video/ogg"
          "video/webm"
          "video/x-flv"
          "video/x-matroska"
          "video/x-msvideo"
        ];
        browser = [
          "text/html"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/about"
          "x-scheme-handler/unknown"
        ];
        directory = [ "inode/directory" ];
        terminal = [
          "terminal"
          "x-terminal-emulator"
          "application/x-shellscript"
        ];
      };

      associations =
        mimeMap
        |> mapAttrsToList (key: map (type: nameValuePair type defaultApps."${key}"))
        |> flatten
        |> listToAttrs;
    in
    {
      hj.xdg.mime-apps = {
        default-applications = associations;
        added-associations = {
          "x-scheme-handler/mpv-handler" = [ "mpv-handler.desktop" ];
          "x-scheme-handler/mpv-handler-debug" = [ "mpv-handler-debug.desktop" ];
          "x-scheme-handler/discord" = [ "vesktop.desktop" ];
          "x-scheme-handler/tg" = [ "telegram.desktop" ];
        };
      };
    };
}
