{
  tack.inputs.cade.url = "github:manic-systems/cade";

  exo.mods.core = { inputs, ... }: {
    imports = [ inputs.cade.nixosModules.default ];

    programs.cade.enable = true;
  };
}
