#   o  .  ▄▀▀▀▄  .▄▀▄ * ▄▀▄ .  ..     o   .-.       +      .   .      |      .
#    +  ▄▀ ▄█▄ ▀▄▀ ▄ ▀▄▀ ▄ ▀▄   +  *       ) ) '   .    *          . -+-       *   .
# +.  ▄▀ ▄█████▄ ▄▛██▄ ▄▛██▄ ▀▄▄▄  ▄▄▄▄   '-´        ▄▄▄▄▄▄  ▄▄▀▀▀▀▄  |  ▄▀▀▀▄
#    █ ▄▛▘  ▀██▓ . ██▓   ██▓  ▄▄ ▀▀ ▄▄ ▀▄  ▄▀▀▀▀▀▀▄▄▀ ▄▄▄▄ ▀▀ ▄▄▓▓▄ ▀▄▄▀▀ ▃▓ ▀▄   o
#   █ ▄▛.*▝▙ ██▓   ██▓  .██▓ ▀▜█▓ .▀▜█▓ █▄▀ ▄████▄  ▄███████▄╱ ▀████▂▂▄▄▓███▓ ▀▄
#   █ ▀▙▁▁▟▘ ██▒   ██▒   ██▒ .▐█▓  .▐█▓ ▀ ▄██▀  ▀████▀▔█▓▔▔▀█▓ ╱+▓██▀▀▀▀█████▒ ▀▄  .
#. ╱ ▀▄ ▀▀ ▄ ██░+  ██░   ██░  ▐█▒.  ▐█▒  ▓██. ⭑ ╱.  ╱' █▒  .█▒╱. ███ █▀▄ ▀████▒ █
# ╱  ╱ ▀▀▀▜▌▗███▖ ▗███▖ ▗███▖ ▟██▖  ▟██▖ ▒██▆▂     ╱  ▗██▖ ▗██▖ ▗███▖▐▌ █ ▀██░ ▄▀.  .
#   ╱ . * ▐▌▝███▘ ▝███▘ ▝███▘ ▜██▘  ▜██▘* ▀█████▆▄✶   ▝██▘ ▝██▘ ▝███▘▐▌  █ ▀░ ▄▀   .
# . o    ▄█▀ ██▒   ██▒ * ██▒ o▐█▓*  ▐█▓ . ╱   .▀███▓ . █▓  +█▓   ▓█▓ █ .. ▀▄▄▄▀   ,
#      ▄▀ ▄▄███░.  ██░  .██▒. ▐█▓ .o▐█▒  ✦  *  ╱ ███▒  █▒' ▄█▒  ▓██▒ ▀▄   ╱  ╱ .:'
#    ▄▀ ▄▀▀▀████▄▄█████▄▄██░  ▝███▄▄███▙▂▁ ☆  ⭑ ▄██░ ▄▄██▄██▒ .▒███▒░ █ .╱ _.::'
#  o █ █ ▄▀▄ ▀▀▀▀▀ ▄▄ ▀▀▀▀▀ ▄▄▄ ▀▀▀▀████▀██▆▆▆██▀▀ ▄▄ ▀██▀▀ ▄▄█▀▀▀██░ █   (_:'  .
#    █ █ ▀▄ ▀▀▀▀▀▀▀ ╱▀▀▀▀▀▀█▀▀▀▀▀██ ▟█░ ▄▄ ▀▀▀ ▄▄▀▀╱ █ ██▄█▀▀ ▄▄▀▄ ▀ ▄▀
#    ▀▄ ▀ █   *    ╱   .  █ ▄███▆▄▄▆█░ ▄▀ ▀▀▀▀▀   ╱  █ ██▀ ▄▀▀   ╱▀▀▀ .     +
# .  ╱ ▀▀▀  o  .     +--  █ ▀ ▄ ▀▀▀▀▀ ▄▀  .   .  ╱  ╱█ █ ▄▀  o  ╱ .      '     .*
#   ╱     .       .      ╱ ▀▀▀ ▀▀▀▀▀▀▀  o       *  ╱ ▀▄▄▄▀            .      o
#      .     *         .           *.              +       ..        o      .      +.
{
  description = "wyspr's Terrible NixOS Configuration";

  outputs =
    { self, ... }:
    let
      inputs = (import ./.tack) // {
        inherit self;
      };

      inherit (inputs.nixpkgs) lib;

      rootPath = ./.;

      projectInput =
        system: input:
        [
          "packages"
          "legacyPackages"
          "devShells"
          "checks"
          "apps"
          "formatter"
        ]
        |> lib.filter (key: input ? ${key} && input.${key} ? ${system})
        |> lib.flip lib.genAttrs (key: input.${key}.${system});

      withSystem =
        system: f:
        f {
          inherit system inputs rootPath;
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          inputs' = inputs |> lib.mapAttrs (_: projectInput system);
          self' = projectInput system self;
          packages' =
            inputs
            |> lib.mapAttrs (_: projectInput system)
            |> lib.mapAttrs (
              inputName: key:
              if key.packages ? default then
                key.packages // key.packages.default
              else if key.packages ? ${inputName} then
                key.packages // key.packages.${inputName}
              else
                key.packages
            );
        };

      #  Evaluate the top-level modules
      topEval = lib.evalModules {
        specialArgs = { inherit inputs withSystem rootPath; };
        modules =
          with lib;
          ./aspects
          |> lib.fileset.fileFilter (file: file.hasExt "nix" && !lib.hasPrefix "_" file.name)
          |> fileset.toList;
      };

      # Evaluate perSystem blocks for each system
      # the output looks like this
      # systemOutputs = { "x86_64-linux" = { packages = "pkg1"; devShells = "shell1"; }; }
      systemOutputs =
        topEval.config.systems
        |> map (system: {
          name = system;
          value = withSystem system (
            specialArgs:
            (lib.evalModules {
              inherit specialArgs;
              modules = [
                topEval.config.perSystem
                { config._module.freeformType = lib.types.lazyAttrsOf lib.types.unspecified; }

              ];
            }).config
          );
        })
        |> lib.listToAttrs;

      # Transpose system-dependent configurations to the top level
      transposed =
        systemOutputs
        |> lib.attrValues
        |> map lib.attrNames
        |> lib.flatten
        |> lib.unique
        |> lib.flip lib.genAttrs (
          key:
          topEval.config.systems
          |> lib.filter (system: systemOutputs.${system} ? ${key})
          |> lib.flip lib.genAttrs (system: systemOutputs.${system}.${key})
        );
    in
    topEval.config.flake // transposed;
}
