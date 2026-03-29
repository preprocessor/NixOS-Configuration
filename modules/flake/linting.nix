{
  inputs,
  self,
  lib,
  ...
}:
{
  flake.modules.nixos.default =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.flint.packages.${pkgs.stdenv.hostPlatform.system}.flint
        pkgs.allfollow
      ];
    };

  flake-file = {
    inputs.flint.url = "github:notashelf/flint";

    prune-lock = {
      enable = true;
      program =
        pkgs:
        pkgs.writeShellApplication {
          name = "allfollow-prune";
          # runtimeInputs = [ inputs.rabid.packages.${pkgs.stdenv.hostPlatform.system}.allfollow ];
          # runtimeInputs = [ pkgs.allfollow ];
          # ${lib.getExe pkgs.allfollow} prune --pretty --in-place "${self.const.cfgdir}/flake.lock"
          text = ''
            allfollow prune --pretty "${self.const.cfgdir}/flake.lock" -fo "${self.const.cfgdir}/flake.lock"
          '';
        };
    };

    # check-hooks = [
    #   {
    #     index = 10;
    #     program =
    #       pkgs:
    #       pkgs.writeShellApplication {
    #         name = "flint-check";
    #         # runtimeInputs = [ inputs.flint.packages.${pkgs.stdenv.hostPlatform.system}.flint ];
    #         text = "flint --merge --check-updates --lockfile " + self.const.cfgdir + "/flake.lock";
    #       };
    #   }
    # ];
  };

}
