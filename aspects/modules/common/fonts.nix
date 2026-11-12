{

  modules.features.desktop =
    { self', pkgs, ... }:
    {
      # hj.packages = [ pkgs.font-manager ];

      my.gtk.fonts = {
        serif = {
          name = "New York";
          package = self'.legacyPackages.apple-fonts.ny;
        };

        sans = {
          name = "SF Pro Display";
          package = self'.legacyPackages.apple-fonts.sf-pro;
        };

        mono = {
          name = "SF Mono";
          package = self'.legacyPackages.apple-fonts.sf-mono;
        };

        emoji = {
          name = "Blobmoji";
          package = pkgs.noto-fonts-emoji-blob-bin;
        };
      };
    };

  modules.host.ramiel =
    { pkgs, self', ... }:
    {
      fonts.packages =
        with self'.legacyPackages;
        [
          fragment-mono-font
          oldschool-pc-fonts
          helvetica-font
          chicago-font
          tiny5-mono
        ]
        ++ [ pkgs.termsyn ];
    };
}
