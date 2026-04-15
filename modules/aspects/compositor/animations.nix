{ inputs, ... }:
{
  flake-file.inputs.niri-shaders-collection = {
    url = "github:jgarza9788/niri-animation-collection";
    flake = false;
  };

  flake.modules.nixos.desktop = {
    custom.programs.niri.settings.extraConfig =
      ''include "${inputs.niri-shaders-collection}/animations/glide.kdl"'';
  };
}
