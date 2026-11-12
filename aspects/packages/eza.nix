{
  perSystem = { pkgs, ... }: {
    remotePackages.eza = pkgs.eza.overrideAttrs (o: {
      doCheck = false;
      patches = (o.patches or [ ]) ++ [
        (pkgs.fetchpatch {
          name = "eza-custom-icons";
          url = "https://gist.githubusercontent.com/preprocessor/e118a8826eab364a16bb8727c03556a9/raw/e072dd188f464f86eb12610f3619fe273fce4bc2/eza-custom-icons.patch";
          hash = "sha256-UxzwkDL+V6vMJr0UnFTJbGBhocDVX30hInVyP+xZbA4=";
        })
      ];
    });
  };
}
