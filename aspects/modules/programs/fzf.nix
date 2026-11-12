{
  modules.core = { scheme, self, ... }: {
    imports = [ self.hjemModules.fzf ];

    my.fzf = {
      enable = true;

      colors = with scheme; {
        "bg+" = base02; # selection background
        "fg+" = base07; # current item text
        "hl" = base0B; # match chars, unselected
        "hl+" = base0B; # match chars, selected
        "info" = base0D; # match count
        "prompt" = base0E; # ❯ prompt
        "pointer" = base0F; # ▶ current line marker
        "marker" = base14; # ● multi-select tick
        "spinner" = base0A; # loading indicator
        "header" = base15; # --header string
        "border" = base02; # border lines
        "gutter" = base00; # gutter bg
      };
      defaultOptions = [
        "--layout=reverse"
        "--border=sharp"
        "--preview-window=sharp"
        "--padding=0,1"
        "--prompt=  "
        "--pointer= "
        "--marker=✓ "
        "--info=inline"
        "--scrollbar=▓"
        "--cycle"
      ];
    };
  };
}
