{ inputs, ... }:

{
  ff.envoy.url = "github:Nixreign/Envoy/dev";
  imports = [ inputs.envoy.flakeModules.envoy ];
}
