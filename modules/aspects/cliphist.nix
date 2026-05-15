{ config, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.cliphist-tui = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
        pname = "cliphist-tui";
        version = "0-unstable-2026-04-26";

        src = pkgs.fetchFromGitHub {
          owner = "SHORiN-KiWATA";
          repo = "cliphist-tui";
          rev = "fd4a47baaba60598603d6c760512d2169479872b";
          hash = "sha256-wjgE9aladixbGfMXVdkvxEBJHKS2BEepbwILZro7d0A=";
        };

        cargoHash = "sha256-KHlEw5RZNeCYeNngPvgDFvBFMKD2OZrx8sg2QWdwjQ8=";
      });
    };

  w.default =
    { self', pkgs, ... }:
    {
      hj.packages = with pkgs; [
        self'.packages.cliphist-tui
        cliphist
      ];

      wrappers.niri.settings.spawn-at-startup = [
        "wl-paste --watch cliphist store"
      ];

      wrappers.otter-launcher.settings.modules =
        let
          resize = config.utils.otterResize;
        in
        [
          {
            description = "clipboard manager";
            prefix = "cc";
            cmd = resize 800 1000 "cliphist-tui";
          }
        ];
    };
}
