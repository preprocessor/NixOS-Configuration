{
  exo.mods.neovim =
    { lib, ... }:
    let
      inherit (lib.nixvim) mkRaw;
    in
    {
      plugins.statuscol = {
        enable = true;
        settings = {
          setopt = true;
          relculright = true;
          segments = [
            {
              text = [ "%s" ];
              click = "v:lua.ScSa";
            }
            {
              text = [
                (mkRaw "require('statuscol.builtin').lnumfunc")
                " "
              ];
              condition = [
                true
                (mkRaw "require('statuscol.builtin').not_empty")
              ];
              click = "v:lua.ScLa";
            }
          ];
        };
      };
    };
}
