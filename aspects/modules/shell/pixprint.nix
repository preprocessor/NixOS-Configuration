{
  tack.pixprint.url = "gh:preprocessor/pixprint";

  w.default =
    { packages', ... }:
    {
      hj.packages = [ packages'.pixprint ];
    };
}
