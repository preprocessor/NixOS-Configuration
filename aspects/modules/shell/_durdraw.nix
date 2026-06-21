{
  perSystem =
    { pkgs, ... }:
    {
      packages.durdraw = pkgs.python3.pkgs.buildPythonApplication {
        pname = "durdraw";
        version = "0.29.0-unstable-2025-03-22";
        src = pkgs.fetchFromGitHub {
          owner = "cmang";
          repo = "durdraw";
          rev = "4177318ec00536acb062db300ab4f309e16c1295";
          hash = "sha256-zlEYwCIhjkrzwcs/nGwKiC6e4R4TTsjaYlEPaLQD0Kg=";
        };
        pyproject = true;
        build-system = with pkgs.python3.pkgs; [
          setuptools
          wheel
        ];
        pythonImportsCheck = [ "durdraw" ];
      };
    };

  w.default =
    { self', ... }:
    {
      hj.packages = [ self'.packages.durdraw ];
    };
}
