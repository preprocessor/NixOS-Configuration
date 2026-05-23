{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.allfollow = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
        pname = "allfollow";
        version = "0-unstable-2025-07-19";

        src = builtins.fetchFromGitHub {
          owner = "spikespaz";
          repo = "allfollow";
          rev = "5e097ac8c6fb8b9e32a3c590090005abe853cccf";
          hash = "sha256-Q9CVcods7Ftcs0KeplhkZOClQKqZy8zwfay02jvNloQ=";
        };

        cargoHash = "sha256-dhj1/5j5SJRnpm26ZjanRwjMX+Uc+V6Ne+d95TOfUBI=";

        meta = {
          description = "A CLI tool to deduplicate your Nix flake's inputs as if you added `inputs.*.inputs.*.follows = \"*\"` everywhere";
          homepage = "https://github.com/spikespaz/allfollow";
          mainProgram = "allfollow";
        };
      });

    };

  w.default.nixpkgs.overlays = [ (_: f: { inherit (self.packages.${f.sys}) allfollow; }) ];
}
