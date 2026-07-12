{
  inputs.pixprint.url = "github:preprocessor/pixprint";

  w.default =
    { packages', ... }:
    {
      hj.packages = [ packages'.pixprint ];
    };
}
