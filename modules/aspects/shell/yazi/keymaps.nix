{ self, ... }:
{
  w.shell = {
    custom.programs.yazi.keymap = {
      mgr.prepend_keymap = [
        {
          on = [
            "g"
            "m"
          ];
          run = "cd /run/media/wyspr/";
          desc = "Go to Media";
        }
        {
          on = [
            "g"
            "r"
          ];
          run = ''shell -- ya emit cd "$(git rev-parse --show-toplevel)"'';
          desc = "Go to git root";
        }
        {
          on = [
            "g"
            "n"
          ];
          run = "cd ${self.const.cfgdir}";
          desc = "Go to NixOS Configuration";
        }
        {
          on = [
            "b"
            "y"
          ];
          run = [
            ''shell -- for path in %s; do echo "file://$path"; done | wl-copy -t text/uri-list''
          ];
          desc = "Copy to clipboard";
        }
        # [INFO] Plugin keymaps below
        {
          on = "+";
          run = "plugin zoom 1";
          desc = "Zoom in hovered file";
        }
        {
          on = "-";
          run = "plugin zoom -1";
          desc = "Zoom out hovered file";
        }
        {
          on = [ "<C-d>" ];
          run = "plugin drag";
          desc = "Drag Files";
        }
        {
          on = [ "h" ];
          run = "plugin bypass reverse";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = [ "l" ];
          run = "plugin bypass smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = "f";
          run = "plugin smart-filter";
          desc = "Smart filter";
        }
        {
          on = "F";
          run = "plugin jump-to-char";
          desc = "Jump to char";
        }
        {
          on = [ "C" ];
          run = "plugin ouch";
          desc = "Compress with ouch";
        }
        {
          on = "u";
          run = "plugin restore";
          desc = "Restore last deleted files/folders";
        }
        {
          on = [ "U" ];
          run = "plugin restore -- --interactive";
          desc = "Restore deleted files/folders (Interactive)";
        }
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = [
            "g"
            "l"
          ];
          run = "plugin lazygit";
          desc = "Open lazygit";
        }
        {
          on = [ "z" ];
          run = "plugin fuzzy-search -- fd --TL=3";
          desc = "Fuzzy Find Files";
        }
        {
          on = [ "<S-s>" ];
          run = "plugin fuzzy-search -- rg --TL=3";
          desc = "Ripgrep Search";
        }
        {
          on = [ "<S-z>" ];
          run = "plugin fuzzy-search -- zoxide --TL=3";
          desc = "Zoxide Search";
        }
      ];
    };
  };
}
