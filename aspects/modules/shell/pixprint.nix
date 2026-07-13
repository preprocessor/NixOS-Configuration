{
  tack.pixprint.url = "gh:preprocessor/pixprint";

  exo.core =
    { packages', ... }:
    {
      hj.packages = [ packages'.pixprint ];
    };
}
