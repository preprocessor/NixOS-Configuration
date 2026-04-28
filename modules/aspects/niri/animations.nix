{
  envoy.niri-shaders-collection.github = "jgarza9788/niri-animation-collection";

  w.desktop =
    { pkgs, envoy, ... }:
    {
      custom.programs.niri.settings.extraConfig =
        ''include "${envoy.niri-shaders-collection.src}/animations/glide.kdl"'';
    };
}
