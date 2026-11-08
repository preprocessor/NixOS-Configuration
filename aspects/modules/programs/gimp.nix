{
  exo.mods.desktop =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        (gimp-with-plugins.override { plugins = with gimpPlugins; [ resynthesizer ]; })
      ];
    };
}
