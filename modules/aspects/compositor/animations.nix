{ inputs, ... }:
{
  flake-file.inputs.niri-shaders-nirimation = {
    url = "github:XansiVA/nirimation";
    flake = false;
  };

  flake.modules.nixos.desktop = {
    custom.programs.niri.settings.extraConfig = /* kdl */ ''
      animations {
          // Uncomment to turn off all animations.
          // off

          // Slow down all animations by this factor. Values below 1 speed them up instead.
          // slowdown 3.0
      }
    '';
    # + "${inputs.niri-shaders-nirimation}/animations/pixelate.kdl";

  };
}
