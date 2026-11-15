{
  modules.host.ramiel =
    {
      pkgs,
      ...
    }:
    let
      cssFile = builtins.fetchurl {
        url = "https://gist.githubusercontent.com/preprocessor/deba75a3e4d6daffcfb81e29bcf3bc35/raw/a80a259411cdb7a2f21a930ad5f5c0a12966092d/chicago-95-custom-colors.css";
        sha256 = "sha256:1ahxrjkhnlx8bsdk6pkmmfwayk3z5jgfd23ldvpbnsmcm3a91bqs";
      };

      chicago95 = pkgs.chicago95.overrideAttrs (old: {
        # Replace the theme's palette with ours but keep its GTK3 @imports, so the
        # stock widget partials render with the scheme colours.
        postInstall = (old.postInstall or "") + ''
          theme="$out/share/themes/Chicago95/gtk-3.0/gtk.css"
          {
            grep -E '^@define-color ' ${cssFile}
            grep -vE '^@define-color ' "$theme"
          } > "$TMPDIR/gtk.css"
          mv "$TMPDIR/gtk.css" "$theme"
        '';
      });
    in
    {
      my.gtk = {
        enable = true;

        icons = {
          name = "Chicago95";
          package = chicago95;
        };

        theme = {
          name = "Chicago95";
          package = chicago95;
        };
      };
    };
}
