{
  exo.mods.neovim = {
    plugins.blink-pairs = {
      enable = true;
      lazyLoad.settings.event = [
        "BufReadPost"
        "BufNewFile"
      ];
      settings.highlights.groups = [
        "BlinkPairsRed"
        "BlinkPairsYellow"
        "BlinkPairsBlue"
        "BlinkPairsOrange"
        "BlinkPairsGreen"
        "BlinkPairsPurple"
        "BlinkPairsCyan"
      ];
    };
  };
}
