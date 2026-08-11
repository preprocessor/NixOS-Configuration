{ lib, ... }:
let
  # This module defines the options and the use of those options to make a wrapped package
  wrapperModule =
    {
      config,
      lib,
      ...
    }:
    {
      options = {
        package = lib.mkOption {
          type = lib.types.package;
          description = "The package to wrap.";
        };

        morePackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = ''
            Additional packages to include in the derivation.

            This differs from extraPkgs, which links packages for use at runtime

            Note: As of writing, packages in extraPackages do not inherit environment
                  variables passed to the wrapper.
          '';
        };

        binName = lib.mkOption {
          type = lib.types.str;
          default = config.package.meta.mainProgram or (lib.getName config.package);
          description = "Name of the wrapped binary at $out/bin/<binName>.";
          apply = lib.escapeShellArg;
        };

        args = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Arguments to pass to the binary";
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

        extraPkgs = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Packages to link at runtime";
        };

        files = lib.mkOption {
          type = with lib.types; attrsOf (either str path);
          default = { };
          description = "Files generated relative to the root of the derivation.";
        };

        aliases = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Aliases to the main binary.";
        };

        wrapper = lib.mkOption {
          type = lib.types.functionTo lib.types.package;
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
              extraPkgs
              morePackages
              files
              aliases
              ;
          in
          pkgs:
          pkgs.symlinkJoin {
            name = "${package.name}-canoli";
            paths = morePackages ++ [
              package
              (pkgs.linkFarm "${package.name}" (
                files
                |> lib.mapAttrsToList (
                  name: value:
                  let
                    path =
                      # If the value IS a string and IS NOT a nix store path
                      if (lib.isString value) && !(lib.hasPrefix builtins.storeDir value) then
                        # Write a text file of the content and return its store path
                        value |> pkgs.writeText "${lib.baseNameOf name}-text"
                      else
                        value;
                  in
                  # Linkfarm expects { name = ..., path = ... }
                  {
                    inherit name path;
                  }
                )
              ))
            ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            meta = removeAttrs (package.meta or { }) [ "outputsToInstall" ] // {
              mainProgram = binName;
            };
            postBuild =
              let
                args' = args |> map (v: "--add-flags ${lib.escapeShellArg v}") |> lib.join " \\\n  ";

                env' =
                  env
                  |> lib.mapAttrsToList (n: v: " --set ${lib.escapeShellArg n} ${lib.escapeShellArg (toString v)}")
                  |> lib.join " \\\n ";

                extraPkgs' = lib.optionalString (extraPkgs != [ ]) " --prefix PATH : ${lib.makeBinPath extraPkgs}";

                aliases' =
                  aliases
                  |> map (alias: "ln -sf $out/bin/${binName} $out/bin/${lib.escapeShellArg alias}")
                  |> lib.concatLines;

                # Each of the prime (') variables above are the correctly processed values for use with makeWrapper

                wrapperArgs = "${args'}${env'}${extraPkgs'}";
              in
              /* bash */ ''
                if [ ! -e $out/bin/${binName} ]; then
                  makeWrapper ${
                    lib.getExe' package (package.meta.mainProgram or (lib.getName package))
                  } $out/bin/${binName} ${wrapperArgs}
                else
                  wrapProgram $out/bin/${binName} ${wrapperArgs}
                fi

                ${lib.optionalString (aliases != [ ]) aliases'}
              '';
          };
      };
    };

  wlib = pkgs: rec {
    inherit pkgs;

    files = placeholder "out";

    buildAndAppend =
      {
        formatter,
        buildFrom,
        appendString ? "",
      }:
      fileName:
      pkgs.runCommand "generate-${fileName}" { } ''
        install -m644 -DT "${formatter.generate "${fileName}" buildFrom}" "$out"
        echo -e "\n${appendString}" >> "$out"
      '';

    buildAndAppend' =
      {
        formatter,
        buildFrom,
        appendString ? "",
      }:
      fileName: {
        "${fileName}" = fileName |> buildAndAppend { inherit formatter buildFrom appendString; };
      };
  };

  wrap =
    pkgs: spec:
    let
      evaluation = lib.evalModules {
        modules = [
          wrapperModule
          spec
        ];
        specialArgs.wlib = wlib pkgs;
      };
    in
    evaluation.config.wrapper pkgs;
in
{
  exo.core =
    { pkgs, ... }:
    {
      _module.args.wrapPackage = wrap pkgs;
      _module.args.wrapPackage' = wrap;
    };

  perSystem =
    { pkgs, ... }:
    {
      _module.args.wrapPackage = wrap pkgs;
      _module.args.wrapPackage' = wrap;
    };

  _file = "wrappers.nix";
}
