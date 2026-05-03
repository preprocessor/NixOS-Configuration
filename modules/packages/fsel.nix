{
  perSystem =
    { pkgs, ... }:
    {
      packages.fsel = pkgs.rustPlatform.buildRustPackage {
        pname = "fsel";
        version = "0-unstable-2026-04-19";

        src = pkgs.fetchFromGitHub {
          owner = "Mjoyufull";
          repo = "fsel";
          rev = "ad49c5d96bb1b1b738c5ce6f4410ecffea8adb5c";
          hash = "sha256-pBQMSlEUICEfmzA+oSonzH0JlAcBjsVE0gT0QwsTNFE=";
        };

        nativeBuildInputs = [ pkgs.pkg-config ];

        doCheck = false;

        # install man page
        postInstall = ''
          install -Dm644 fsel.1 $out/share/man/man1/fsel.1
        '';

        cargoHash = "sha256-hNDiVdEOT3X6YSjggZgj1ZMpy4Ttcu3H7UKe/R1pJfY=";
      };
    };

  w.default =
    { self', ... }:
    {
      hj.packages = [ self'.packages.fsel ];
    };
}
