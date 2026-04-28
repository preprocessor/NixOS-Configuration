{
  envoy.apple-emoji.url = "https://github.com/samuelngs/apple-emoji-ttf/releases/download/macos-26-20260219-2aa12422/AppleColorEmoji-Linux.ttf";

  w.default =
    {
      envoy,
      nvfetcher,
      lib,
      ...
    }:
    {
      nixpkgs.overlays = [
        (_: f: {
          apple-emoji = f.mkDerivation (finalAttrs: {
            inherit (envoy.apple-emoji) pname version src;

            dontUnpack = true;
            dontBuild = true;
            dontConfigure = true;

            installPhase = ''
              install -D -m644 $src $out/share/fonts/truetype/AppleColorEmoji-Linux.ttf
            '';

            meta = {
              homepage = "https://github.com/samuelngs/apple-emoji-linux";
              description = "Apple Color Emoji for Linux";
              license = lib.licenses.asl20;
            };
          });
        })
      ];
    };
}
