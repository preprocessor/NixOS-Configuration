{ lib, ... }:
let
  # This module defines the options and the use of those options to make a wrapped package
  wrapperModule =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      options = {
        package = lib.mkOption {
          type = lib.types.package;
          description = "The package to wrap.";
        };

        linkedPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = ''
            Additional packages to include in the output by symlinking them into the derivation root.

            This differs from runtimePackages, which links packages for use at runtime with the makeWrapper lib

            Note: As of writing, packages in extraPackages do not inherit environment variables passed to the wrapper.
          '';
        };

        binName = lib.mkOption {
          type = lib.types.str;
          default = config.package.meta.mainProgram or (lib.getName config.package);
          description = "Name of the wrapped binary at $out/bin/<binName>.";
        };

        args = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Arguments to pass to the binary";
        };

        runCommand = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Run commands before the executable";
        };

        env = lib.mkOption {
          type =
            with lib.types;
            attrsOf (oneOf [
              str
              number
              bool
              path
            ]);
          default = { };
          description = "Environment variables to pass to the binary";
        };

        runtimePackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Packages to add to PATH at runtime";
        };

        files = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                relPath = lib.mkOption {
                  type = lib.types.str;
                  description = "Path relative to the root of the output.";
                };

                file = lib.mkOption {
                  type = with lib.types; either str pathInStore;
                  description = ''
                    File or directory to add to the output.
                  '';
                };
              };
            }
          );

          default = { };
          description = ''
            Files or directories to add to the output.

            Strings are passed through passAsFile. Store paths are linked directly into the output.
          '';
        };

        aliases = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Aliases to the main binary.";
        };

        wrapper = lib.mkOption {
          type = lib.types.package;
          readOnly = true;
          description = "The built, wrapped derivation.";
        };
      };

      config = {
        wrapper =
          let
            inherit (config)
              package
              binName
              args
              env
              runtimePackages
              linkedPackages
              files
              aliases
              runCommand
              ;

            args' = args |> lib.concatMapStringsSep " " (v: "--add-flags ${lib.escapeShellArg v}");

            env' =
              env
              |> lib.concatMapAttrsStringSep " " (
                name: value: " --set ${lib.escapeShellArg name} ${lib.escapeShellArg (toString value)}"
              );

            runtimePackages' = lib.optionalString (
              runtimePackages != [ ]
            ) " --prefix PATH : ${lib.makeBinPath runtimePackages}";

            runCommand' = runCommand |> lib.concatMapStringsSep " " (v: " --run ${lib.escapeShellArg v}");

            wrapperArgs = "${args'}${env'}${runtimePackages'}${runCommand'}";

            mainBin = lib.escapeShellArg binName;

            # Each of the prime (') variables above are the correctly processed values for use with makeWrapper

            # Files passed as strings that are NOT store paths
            stringFiles =
              files
              |> lib.filterAttrs (_: { file, ... }: lib.isString file && !lib.hasPrefix builtins.storeDir file);
            # Files to be symlinked; filter the base `files` attrset via inversion of `stringFiles` attrNames
            symFiles = files |> lib.filterAttrs (name: _: !lib.elem name (lib.attrNames stringFiles));
            # I'm lazy
            catmap =
              f: x: (if lib.isAttrs x then lib.concatMapAttrsStringSep else lib.concatMapStringsSep) "\n" f x;
          in
          pkgs.runCommandLocal "${package.name}-wrapper"
            (
              {
                passAsFile = lib.attrNames stringFiles;
                nativeBuildInputs = with pkgs; [
                  makeWrapper
                  lndir
                ];
                meta = removeAttrs (package.meta or { }) [ "outputsToInstall" ] // {
                  mainProgram = binName;
                };
              }
              // (stringFiles |> lib.mapAttrs (_: { file, ... }: file))
            )
            /* bash */ ''
              mkdir -p $out

              # Link the main package and any additional packages.
              ${[ package ] ++ linkedPackages |> catmap (pkg: "lndir -silent ${pkg} $out")}

              # Generate files with passAsFile
              ${
                stringFiles
                |> catmap (attrName: { relPath, ... }: ''install -D "''$${attrName}Path" "$out/${relPath}"'')
              }

              # Generate symlinks from external paths
              ${
                symFiles
                |> catmap (
                  _:
                  { relPath, file }:
                  ''
                    mkdir -p "$out/${lib.dirOf relPath}"
                    ln -sf ${file} "$out/${relPath}"
                  ''
                )
              }

              if [ ! -e $out/bin/${mainBin} ]; then
                makeWrapper ${
                  lib.getExe' package (package.meta.mainProgram or (lib.getName package))
                } $out/bin/${mainBin} ${wrapperArgs}
              else
                wrapProgram $out/bin/${mainBin} ${wrapperArgs}
              fi

              ${aliases |> catmap (alias: "ln -sf $out/bin/${mainBin} $out/bin/${lib.escapeShellArg alias}")}
            '';
      };
    };

  wrapperUtils = (
    { config, pkgs, ... }:
    {
      _module.args = {
        files =
          config.files
          |> lib.mapAttrs (
            _:
            { relPath, ... }:
            {
              __toString = _: "${placeholder "out"}/${relPath}";

              dir = "${placeholder "out"}/${lib.dirOf relPath}";
            }
          );

        wlib = rec {
          out = placeholder "out";
          generate = fmt: (fmt { }).generate;

          json = generate pkgs.formats.json;
          toml = generate pkgs.formats.toml;
          yaml = generate pkgs.formats.yaml;
          ini = generate pkgs.formats.ini;
        };
      };
    }
  );

  wrap =
    pkgs: spec:
    let
      evaluation = lib.evalModules {
        modules = [
          wrapperModule
          wrapperUtils
          spec
        ];
        specialArgs = { inherit pkgs; };
      };
    in
    evaluation.config.wrapper;

  wrapModule =
    { pkgs, ... }:
    {
      _module.args.wrapPackage = wrap pkgs;
    };
in
{
  exo.core = wrapModule;
  perSystem = wrapModule;
}
