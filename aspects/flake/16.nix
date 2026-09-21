{ lib, ... }:
{
  options.schemes = lib.mkOption {
    type = lib.types.attrsOf lib.types.attrs;
    description = "A set of base16/24 colorschemes";
  };

  config._module.args =
    let
      #
      # This serves as a highly stripped down base16.nix that has no dependency on pkgs
      #
      # This does not support loading files, and instead of withHashtag I have inverted this to noHashtag
      #
      # much of the following code is directly lifted or adapted from here:
      #   https://github.com/SenchoPens/base16.nix/blob/75ed5e5e3fce37df22e49125181fa37899c3ccd6/lib/colors.nix
      primaryHex2Dec =
        hex:
        let
          hex2decDigits = rec {
            "0" = 0;
            "1" = 1;
            "2" = 2;
            "3" = 3;
            "4" = 4;
            "5" = 5;
            "6" = 6;
            "7" = 7;
            "8" = 8;
            "9" = 9;
            A = 10;
            B = 11;
            C = 12;
            D = 13;
            E = 14;
            F = 15;
            a = A;
            b = B;
            c = C;
            d = D;
            e = E;
            f = F;
          };
        in
        16 * hex2decDigits."${builtins.substring 0 1 hex}" + hex2decDigits."${builtins.substring 1 1 hex}";

      hexToRgb = hex: {
        r = primaryHex2Dec (builtins.substring 0 2 hex);
        g = primaryHex2Dec (builtins.substring 2 2 hex);
        b = primaryHex2Dec (builtins.substring 4 2 hex);
      };

      ensureBase24 =
        scheme:
        {
          base10 = scheme.base00;
          base11 = scheme.base00;
          base12 = scheme.base08;
          base13 = scheme.base0A;
          base14 = scheme.base0B;
          base15 = scheme.base0C;
          base16 = scheme.base0D;
          base17 = scheme.base0E;
        }
        // scheme;

      addMnemonicNames =
        scheme:
        {
          red = scheme.base08;
          orange = scheme.base09;
          yellow = scheme.base0A;
          green = scheme.base0B;
          cyan = scheme.base0C;
          blue = scheme.base0D;
          magenta = scheme.base0E;
          brown = scheme.base0F;
          bright-red = scheme.base12;
          bright-yellow = scheme.base13;
          bright-green = scheme.base14;
          bright-cyan = scheme.base15;
          bright-blue = scheme.base16;
          bright-magenta = scheme.base17;
        }
        // scheme;

      abs = v: if v < 0 then 0 - v else v;

      round =
        float: # 4.2
        let
          int = builtins.floor float; # 4
          decimal = float - int; # 4.2 - 4 = 0.2
        in
        if decimal < 0.5 then int else builtins.ceil float;

      stripHashtag = lib.removePrefix "#";
    in
    {
      averageColors =
        {
          startColor,
          endColor,
          steps ? 1.0,
        }:
        let
          startRgb = hexToRgb (stripHashtag startColor);
          endRgb = hexToRgb (stripHashtag endColor);

          deltas = {
            r = startRgb.r - endRgb.r;
            g = startRgb.g - endRgb.g;
            b = startRgb.b - endRgb.b;
          };

          partials = deltas |> lib.mapAttrs (_: c: c / (steps + 1.0));
        in
        steps
        |> builtins.genList (
          i: startRgb |> lib.mapAttrs (n: v: lib.trivial.toHexString (round (v + ((i + 1) * partials.${n}))))
        )
        |> map (v: "#${v.r}${v.g}${v.b}");

      mkScheme =
        schema:
        let
          scheme = schema |> ensureBase24 |> addMnemonicNames;
          noHashtag = scheme |> lib.mapAttrs (_: v: stripHashtag v);
          asRgb8 = noHashtag |> lib.mapAttrs (_: v: hexToRgb v);
          asRgb = asRgb8 |> lib.mapAttrs (_: rgb: lib.mapAttrs (_: c: c / 256.0) rgb);
        in
        scheme // { inherit noHashtag asRgb8 asRgb; };
    };
}
