{
  tack.inputs.cade.url = "gh:manic-systems/cade";

  modules.core = { inputs, ... }: {
    imports = [ inputs.cade.nixosModules.default ];

    programs.cade.enable = true;
  };
}
