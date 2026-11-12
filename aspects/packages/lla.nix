{
  perSystem =
    { pkgs, ... }:
    {
      remotePackages.lla = pkgs.lla.overrideAttrs {
        doCheck = false;
        postPatch = ''
          substituteInPlace lla/src/formatter/column_config.rs \
            --replace-fail '"Permissions".to_string()' '"Perms".to_string()'
        '';
      };
    };
}
