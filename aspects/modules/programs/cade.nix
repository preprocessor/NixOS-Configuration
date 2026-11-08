{
  tack.inputs.cade.url = "gh:manic-systems/cade";

  exo.core = { inputs, ... }: {
    imports = [ inputs.cade.nixosModules.default ];

    programs.cade.enable = true;
  };
}
