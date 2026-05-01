{
  envoy.apple-emoji.url = "https://github.com/samuelngs/apple-emoji-linux/releases/latest/download/AppleColorEmoji-Linux.ttf";

  w.default =
    { envoy, lib, ... }:
    {
      nixpkgs.overlays = [
        (_: f: {
          apple-emoji = f.stdenv.mkDerivation {
            inherit (envoy.apple-emoji) pname version src;

            dontUnpack = true;
            dontBuild = true;
            dontConfigure = true;

            installPhase = "install -D -m644 $src $out/share/fonts/truetype/AppleColorEmoji-Linux.ttf";

            meta = {
              homepage = "https://github.com/samuelngs/apple-emoji-linux";
              description = "Apple Color Emoji for Linux";
              license = lib.licenses.asl20;
            };
          };
        })
      ];
    };
}
