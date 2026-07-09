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
      tackInputs = import ./.tack;

      inherit (tackInputs.nixpkgs) lib;

      inputs = tackInputs // {
        self = self';
      };

      self' = flakeOutputs // {
        inherit inputs;
        inherit (self) outPath;
      };

      flakeOutputs =
        tackInputs.flake-parts.lib.evalFlakeModule { inherit inputs; } {
          imports =
            with lib;
            ./aspects
            |> fileset.fileFilter (file: file.hasExt "nix" && !hasPrefix "_" file.name)
            |> fileset.toList;
          _module.args.rootPath = ./.;
        }
        |> (eval: { inherit eval; } // eval.config.processedFlake);
    in
    flakeOutputs;

}
