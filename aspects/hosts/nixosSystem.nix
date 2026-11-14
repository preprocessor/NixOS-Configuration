{
  withSystem,
  inputs,
  self,
  ...
}:
{
  config._module.args.nixosSystemMinimal =
    {
      system,
      modules,
      extraSpecialArgs ? { },
    }:
    withSystem system (
      {
        packages',
        inputs',
        self',
        meta,
        rootPath,
        ...
      }:
      ""
    );
}
