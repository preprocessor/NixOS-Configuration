{
  tack.inputs = {
    lithic = {
      url = "gh:NotAShelf/lithic";
      group = "gaming";
    };
    vintage-story-nix = {
      url = "gh:PierreBorine/vintagestory-nix";
      group = "gaming";
    };
  };

  perSystem = { packages', ... }: {
    remotePackages = { inherit (packages') lithic; };
  };

  exo.mods.gaming = { packages', ... }: {
    hj.packages = with packages'; [
      vintage-story-nix.latest
      lithic
    ];
  };
}
