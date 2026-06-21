{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.flake-file.flakeModules.default
    (lib.mkAliasOptionModule [ "inputs" ] [ "flake-file" "inputs" ])
  ];

  disabledModules = [ (inputs.flake-file + "/modules/flake-parts.nix") ];

  perSystem =
    { pkgs, ... }:
    {
      apps =
        config.flake-file.apps
        |> lib.mapAttrs (
          _: f:
          let
            pkg = f pkgs;
          in
          {
            type = "app";
            program = lib.getExe pkg;
          }
        );

      checks.check-flake-file = config.flake-file.check-flake-file pkgs;
    };

  flake-file = {
    inputs.flake-file.url = "github:denful/flake-file";

    description = "wyspr's Terrible NixOS Configuration";

    outputs = /* nix */ ''
      inputs: let
        evaluation = inputs.flake-parts.lib.evalFlakeModule {inherit inputs;} {
          # Import all *.nix files in the ./aspects directory
          # Except ones that start with '_'
          imports =
            with inputs.nixpkgs.lib;
            ./aspects
            |> fileset.fileFilter (file: file.hasExt "nix" && !hasPrefix "_" file.name)
            |> fileset.toList;

          _module.args.rootPath = ./.;
        };
      in
        { inherit evaluation; } // evaluation.config.processedFlake
    '';

    do-not-edit = ''
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
      #
      # This file is generated with flake-file. Any edits will be overwritten.
    '';
  };
}
