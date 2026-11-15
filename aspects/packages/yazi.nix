{
  tack.inputs.sxyazi = {
    url = "gh:sxyazi/yazi";
    group = "yazi";
  };

  perSystem = { inputs', pkgs, ... }: {
    remotePackages.yazi = inputs'.sxyazi.packages.default.override {
      yazi-unwrapped = inputs'.sxyazi.packages.yazi-unwrapped.overrideAttrs (prev: {
        doCheck = false;
        nativeBuildInputs = (prev.nativeBuildInputs or [ ]) ++ [ pkgs.pkg-config ];
        buildInputs = (prev.buildInputs or [ ]) ++ [ pkgs.oniguruma ];
      });
    };
  };
}
