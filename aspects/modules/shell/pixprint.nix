{
  ff.pixprint.url = "github:preprocessor/pixprint";

  w.default =
    { pkgs, inputs', ... }:
    {
      hj.packages = [ inputs'.pixprint.packages.default ];
    };
}
