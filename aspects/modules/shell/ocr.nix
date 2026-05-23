{
  perSystem =
    { pkgs, self', ... }:
    {
      packages.ocr = pkgs.writeShellApplication {
        name = "ocr";

        runtimeInputs = with pkgs; [
          grim
          libnotify
          slurp
          tesseract5
          wl-clipboard-rs
        ];

        text = /* bash */ ''
          selection=$(slurp 2>/dev/null || true)

          if [ -z "$selection" ]; then
            notify-send "OCR" "Cancelled by user"
            exit 0
          fi

          grim -g "$selection" -t ppm - \
            | tesseract -l "eng" - - \
            | wl-copy

          notify-send "OCR" "Text copied to clipboard"
        '';
      };
    };

  w.default =
    { self', ... }:
    {
      nixpkgs.overlays = [ (_: f: { inherit (self'.packages) ocr; }) ];
    };
}
