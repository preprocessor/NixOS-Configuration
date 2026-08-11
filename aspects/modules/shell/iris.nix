{
  tack.inputs.iris.url = "gh:versenilvis/iris/main";

  exo.mods.desktop =
    { packages', ... }:
    {
      hj.packages = [
        packages'.iris
      ];

      programs.fish.interactiveShellInit = /* fish */ ''
        if command -v iris >/dev/null 2>&1
            alias i="iris"
        end
      '';
    };
}
