#
#         ▄▀▀▀▄   ▄▀▄   ▄▀▄
#       ▄▀ ▄█▄ ▀▄▀ ▄ ▀▄▀ ▄ ▀▄
#     ▄▀ ▄█████▄ ▄▛██▄ ▄▛██▄ ▀▄▄▄  ▄▄▄▄              ▄▄▄▄▄▄  ▄▄▀▀▀▀▄     ▄▀▀▀▄
#    █ ▄▛▘  ▀██▓   ██▓   ██▓  ▄▄ ▀▀ ▄▄ ▀▄  ▄▀▀▀▀▀▀▄▄▀ ▄▄▄▄ ▀▀ ▄▄▓▓▄ ▀▄▄▀▀ ▃▓ ▀▄
#   █ ▄▛  ▝▙ ██▓   ██▓   ██▓ ▀▜█▓  ▀▜█▓ █▄▀ ▄████▄  ▄███████▄  ▀████▂▂▄▄▓███▓ ▀▄
#   █ ▀▙▁▁▟▘ ██▒   ██▒   ██▒  ▐█▓   ▐█▓ ▀ ▄██▀  ▀████▀▔█▓▔▔▀█▓   ▓██▀▀▀▀█████▒ ▀▄
#    ▀▄ ▀▀ ▄ ██░   ██░   ██░  ▐█▒   ▐█▒  ▓██           █▒   █▒   ███ █▀▄ ▀████▒ █
#      ▀▀▀▜▌▗███▖ ▗███▖ ▗███▖ ▟██▖  ▟██▖ ▒██▆▂        ▗██▖ ▗██▖ ▗███▖▐▌ █ ▀██░ ▄▀
#         ▐▌▝███▘ ▝███▘ ▝███▘ ▜██▘  ▜██▘  ▀█████▆▄    ▝██▘ ▝██▘ ▝███▘▐▌  █ ▀░ ▄▀
#        ▄█▀ ██▒   ██▒   ██▒  ▐█▓   ▐█▓        ▀███▓   █▓   █▓   ▓█▓ █    ▀▄▄▄▀
#      ▄▀ ▄▄███░   ██░   ██▒  ▐█▓   ▐█▒          ███▒  █▒  ▄█▒  ▓██▒ ▀▄
#    ▄▀ ▄▀▀▀████▄▄█████▄▄██░  ▝███▄▄███▙▂▁      ▄██░ ▄▄██▄██▒  ▒███▒░ █
#    █ █ ▄▀▄ ▀▀▀▀▀ ▄▄ ▀▀▀▀▀ ▄▄▄ ▀▀▀▀████▀██▆▆▆██▀▀ ▄▄ ▀██▀▀ ▄▄█▀▀▀██░ █
#    █ █ ▀▄ ▀▀▀▀▀▀▀  ▀▀▀▀▀▀█▀▀▀▀▀██ ▟█░ ▄▄ ▀▀▀ ▄▄▀▀  █ ██▄█▀▀ ▄▄▀▄ ▀ ▄▀
#    ▀▄ ▀ █               █ ▄███▆▄▄▆█░ ▄▀ ▀▀▀▀▀      █ ██▀ ▄▀▀    ▀▀▀
#      ▀▀▀                █ ▀ ▄ ▀▀▀▀▀ ▄▀             █ █ ▄▀
#                          ▀▀▀ ▀▀▀▀▀▀▀               ▀▄▄▄▀
#
{
  description = "wyspr's departed flake";

  outputs =
    { self, ... }:
    let
      # Import inputs from tack: https://github.com/manic-systems/tack/
      inputs = (import ./.tack) // {
        inherit self;
      };

      inherit (inputs.nixpkgs) lib;

      # The flake's root directory as a path value gets threaded through to every module later via specialArgs,
      # so modules can reference files relative to the repo root without doing path gymnastics themselves.
      rootPath = ./.;

      # projectInput: take one flake-shaped input and project it down to just the outputs it has for one
      # specific system ("x86_64-linux").
      #
      # A raw flake output set looks like:
      #   {
      #     packages.x86_64-linux.foo = ...;
      #     devShells.aarch64-darwin.bar = ...;
      #     devShells.x86_64-linux.foo = ...;
      #     ...
      #   }
      # and this turns that into:
      #   for system = "x86_64-linux":
      #     {
      #       packages.foo = ...;
      #       devShells.foo = ...;
      #     }
      #   for system = "aarch64-darwin":
      #     {
      #       devShells.bar = ...;
      #     }
      #
      # it strips the system layer out and only keeps the categories that actually exist for that system.
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
        # Keep only the category names that
        #   a) actually exist on this input
        #   b) have an entry for this specific system.
        # This guards against inputs that don't export a given category (a flake with no apps) and against inputs
        # that support some systems but not others (nixpkgs itself has legacyPackages, but no packages at the
        # top level, input ? ${key} catches that safely
        |> lib.filter (key: input ? ${key} && input.${key} ? ${system})
        # Turn that filtered list of category names into an actual attrset
        # by looking up input.<key>.<system> for each surviving key
        |> lib.flip lib.genAttrs (key: input.${key}.${system});

      # This is a hand-rolled version of flake-parts' withSystem.
      # withSystem: builds the "perSystem args" bundle for one system and hands it to a callback f.
      withSystem =
        system: f:
        f rec {
          # re-expose these so every perSystem module gets them for free
          inherit system inputs rootPath;

          # The nixpkgs package set for this specific system
          pkgs = inputs.nixpkgs.legacyPackages.${system};

          # Every input, projected down to "just this input's system-specific  outputs" via projectInput.
          # So now:
          #   inputs'.someFlake.packages.foo
          # is shorthand for:
          #   inputs.someFlake.packages.${system}.foo
          inputs' = inputs |> lib.mapAttrs (_: projectInput system);

          # Same idea but for this flake's own outputs, this gives you self'.packages.foo.
          self' = projectInput system self;

          # packages': a convenience layer on top of inputs'.<name>.packages
          #
          # So now:
          #   packages'.someInput
          # is shorthand for:
          #   inputs.foo.packages.${system}.default
          # or
          #   inputs.foo.packages.${system}.${foo}
          # or
          #   inputs.foo.packages.${system}
          #
          # It chooses the package based on the above priority, (default > inputName > { packages = { }; })
          packages' =
            inputs'
            |> lib.mapAttrs (
              inputName: projectedAttrs:
              let
                inherit (projectedAttrs) packages;
                # 1. Try packages.default first
                # 2. Try a package literally named after the input itself (an input called foo exposing packages.foo)
                # 3. fall back to {} so the merge below is a no-op.
                spec = packages.default or packages.${inputName} or { };
              in
              packages // spec
            );
        };

      # Integral options for departed, this is merged with topEval's module list
      topOptions = {
        options = {
          systems = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ "x86_64-linux" ];
            description = ''
              A list of systems this flake supports, passed to perSystem for tranpositioning
            '';
          };

          flake = lib.mkOption {
            type = lib.types.lazyAttrsOf lib.types.unspecified;
            default = { };
            description = ''
              Flake level options, things like: flake.nixosConfigurations, flake.overlays,
              or anything else set with config.flake by top-level modules.
            '';
          };

          perSystem = lib.mkOption {
            type = lib.types.deferredModule;
            default = { };
            description = ''
              The same fragment gets re-evaluated once per system, with additional system-specific  specialArgs passed.

              additional specialArgs: self', inputs', packages'
            '';
          };
        };
      };

      # topEval: the FIRST of two evalModules passes. This one evaluates the top-level modules
      topEval = lib.evalModules {
        # specialArgs get handed to every module function as extra function arguments.
        # So any file under ./aspects can just write at the top
        #   { inputs, withSystem, rootPath, ... }: { ... }
        # and pull these out of specialArgs.
        specialArgs = { inherit inputs withSystem rootPath; };
        modules =
          (
            ./aspects
            # Walk the ./aspects directory and keep only entries that
            #   a) end in .nix
            #   b) don't start with _.
            |> lib.fileset.fileFilter (file: file.hasExt "nix" && !lib.hasPrefix "_" file.name)
            |> lib.fileset.toList
          )
          ++ [ topOptions ];
      };

      # Evaluate perSystem blocks for each system
      # the output looks like this
      # systemOutputs = { "x86_64-linux" = { packages = P; devShells = D; }; }
      # where P and D are { item = derivation, ...  }
      systemOutputs =
        topEval.config.systems
        |> lib.flip lib.genAttrs (
          system:
          # withSystem builds the args bundle for this system (pkgs, inputs', self', packages', ...)
          # and feeds it in below as specialArgs for the inner evalModules call.
          withSystem system (
            specialArgs:
            (lib.evalModules {
              inherit specialArgs;
              modules = [
                topEval.config.perSystem
                # This is a hand-rolled version of flake-parts' perSystem.
                # perSystem : the same fragment gets re-evaluated once per system,
                # each time with different specialArgs (a different pkgs, system, inputs', etc).
                #
                # Setting freeformType to "lazyAttrsOf unspecified"
                # lets every possible key someone might set be valid inside perSystem,
                # with no options for any of that declared up front anywhere.
                { config._module.freeformType = lib.types.lazyAttrsOf lib.types.unspecified; }
              ];
              # .config pulls out just the evaluated attrset of values not the whole evalModules result,
              # which also bundles things like .options and .type that we don't care about here.
            }).config
          )
        );

      # transposed: swap the keys
      #
      # systemOutputs is shaped
      #   system -> category -> drv (derivation) (ex: x86_64-linux.packages.foo)
      # but flake outputs need to be shaped the other way around:
      #   category -> system -> drv              (ex: packages.x86_64-linux.foo)
      #
      # this walks every system's output set and folds each one into an accumulator, transposed into the correct key.
      transposed =
        systemOutputs
        # For this one system, wrap every top-level category's value in { ${system} = value; }
        # turning:
        #   systemOutputs.${system} = { packages = P; devShells = D; } where P and D are { foo = drv, bar = drv, ... }
        # into:
        #   { packages = { ${system} = P; }; devShells = { ${system} = D; }; }
        |> lib.mapAttrsToList (system: lib.mapAttrs (category: drv: { ${system} = drv; }))
        # which is now shaped correctly to be merged into the accumulator.
        |> lib.foldAttrs (category: acc: acc // category) { }; # { } is the starting accumulator for the fold
    in
    # Final result: the perSystem stuff we just transposed (packages.<system>, devShells.<system>, checks.<system>, etc.)
    # merged with whatever system-independent flake outputs got declared directly,
    # things like: flake.nixosConfigurations, flake.overlays, or anything else set
    # with config.flake by the top-level modules.
    transposed // topEval.config.flake;
}
