{
  modules.features.desktop = { self', ... }: {
    hj.packages = [ self'.packages.hyprprop ];
  };
}
