{ inputs, ... }:
let
  driftwm = inputs.driftwm.packages.x86_64-linux.default;
in
{
  flake.modules.nixos.default = {
    services.displayManager.sessionPackages = [ driftwm ];
    environment.systemPackages = [ driftwm ];
  };
}
