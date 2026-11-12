{
  modules.features.desktop = { self, ... }: {
    imports = with self.hjemModules; [
      xdg-desktop-entries
      quickshell
      app2unit
      zathura
      gtk
    ];
  };
}
