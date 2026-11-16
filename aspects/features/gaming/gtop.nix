{
  modules.features.gaming = { self', lib, ... }: {
    programs.fish.shellAliases.gtop = lib.getExe self'.packages.gtop;
  };
}
