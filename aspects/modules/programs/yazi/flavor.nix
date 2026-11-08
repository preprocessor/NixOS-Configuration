{
  exo.core =
    { scheme, ... }:
    {
      my.yazi.flavor = with scheme; {
        mgr = {
          cwd.fg = base05;
          border_set.as = "plain";
          border_style.fg = base05;

          find_keyword = {
            fg = bright-red;
            bold = true;
            italic = true;
            underline = true;
          };
          find_position = {
            fg = bright-red;
            bold = true;
            italic = true;
          };

          marker_copied = {
            fg = magenta;
            bg = magenta;
          };
          marker_cut = {
            fg = magenta;
            bg = magenta;
          };
          marker_marked = {
            fg = bright-red;
            bg = bright-red;
          };
          marker_selected = {
            fg = bright-magenta;
            bg = bright-magenta;
          };

          count_copied = {
            fg = base07;
            bg = magenta;
          };
          count_cut = {
            fg = base07;
            bg = magenta;
          };
          count_selected = {
            fg = base11;
            bg = bright-magenta;
          };
        };

        indicator = {
          border_set.as = "plain";
          padding = {
            open = "▐";
            close = "▌";
          };
          parent = {
            fg = base11;
            bg = yellow;
          };
          current = {
            fg = base11;
            bg = bright-yellow;
          };
        };

        status = {
          overall = {
            bg = base10;
            fg = bright-blue;
          };
          sep_left = {
            open = "";
            close = "";
          };
          sep_right = {
            open = "";
            close = "";
          };

          progress_label.bold = true;
          progress_normal = {
            fg = bright-blue;
            bg = base00;
          };
          progress_error = {
            fg = bright-red;
            bg = base00;
          };

          perm_type.fg = bright-blue;
          perm_write.fg = bright-magenta;
          perm_exec.fg = bright-red;
          perm_read.fg = magenta;
          perm_sep.fg = bright-blue;
          border_set.as = "plain";
        };

        mode = {
          normal_main = {
            bg = bright-cyan;
            fg = base11;
            bold = true;
          };
          normal_alt = {
            bg = base02;
            fg = base04;
          };

          select_main = {
            bg = yellow;
            fg = base01;
            bold = true;
          };
          select_alt = {
            bg = base02;
            fg = base04;
          };

          unset_main = {
            bg = bright-magenta;
            fg = base10;
            bold = true;
          };
          unset_alt = {
            bg = base02;
            fg = base04;
          };
          border_set.as = "plain";
        };

        input = {
          border.fg = bright-blue;
          title = { };
          value.fg = base05;
          selected.reversed = true;
          border_set.as = "plain";
        };

        tabs = {
          border_set.as = "plain";
          active = {
            fg = base00;
            bold = true;
            bg = yellow;
          };
          inactive = {
            fg = yellow;
            bg = base00;
          };
          sep_inner = {
            open = "";
            close = "";
          };
          sep_outer = {
            open = "";
            close = "";
          };
        };

        cmp = {
          border = {
            fg = bright-blue;
            bg = base11;
          };
          border_set.as = "plain";
        };

        tasks = {
          border.fg = bright-blue;
          title = { };
          hovered = {
            fg = magenta;
            underline = true;
          };
          border_set.as = "plain";
        };

        confirm.border_set.as = "plain";
        app.border_set.as = "plain";
        pick.border_set.as = "plain";

        which = {
          cols = 3;
          mask.bg = base00;
          cand.fg = bright-blue;
          rest.fg = base11;
          desc.fg = base05;
          separator = " ▶ ";
          separator_style.fg = base05;
          border_set.as = "plain";
        };

        spot = {
          border.fg = bright-blue;
          title.fg = bright-blue;
          tbl_col.fg = base05;
          tbl_cell = {
            fg = base05;
            bg = base00;
          };
          border_set.as = "plain";
        };

        help = {
          on.fg = base05;
          run.fg = base05;
          hovered = {
            reversed = true;
            bold = true;
          };
          footer = {
            fg = base01;
            bg = bright-blue;
          };
          border_set.as = "plain";
        };

        notify = {
          title_info.fg = bright-magenta;
          title_warn.fg = bright-blue;
          title_error.fg = bright-red;
          border_set.as = "plain";
        };

        filetype = {
          rules = [
            {
              mime = "image/*";
              fg = bright-cyan;
            }
            {
              mime = "{audio,video}/*";
              fg = bright-yellow;
            }
            {
              mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
              fg = bright-magenta;
            }
            {
              mime = "application/{pdf,doc,rtf}";
              fg = green;
            }
            {
              mime = "*";
              is = "orphan";
              fg = red;
              bg = brown;
            }
            {
              mime = "application/*exec*";
              fg = bright-red;
            }
            {
              url = "*";
              fg = base05;
            }
            {
              url = "*/";
              fg = base05;
            }
          ];
        };

        icon = {
          globs = [ ];
          dirs = [
            {
              name = ".config";
              text = "";
              fg = yellow;
            }
            {
              name = ".git";
              text = "";
              fg = green;
            }
            {
              name = ".github";
              text = "";
              fg = yellow;
            }
            {
              name = ".npm";
              text = "";
              fg = yellow;
            }
            {
              name = "Desktop";
              text = "";
              fg = base09;
            }
            {
              name = "Projects";
              text = "󱀫";
              fg = bright-green;
            }
            {
              name = "Repos";
              text = "󰳐";
              fg = bright-blue;
            }
            {
              name = "Documents";
              text = "";
              fg = cyan;
            }
            {
              name = "Downloads";
              text = "";
              fg = base05;
            }
            {
              name = "NixOS";
              text = "";
              fg = blue;
            }
            {
              name = "Nix";
              text = "";
              fg = blue;
            }
            {
              name = "Library";
              text = "";
              fg = yellow;
            }
            {
              name = "Movies";
              text = "";
              fg = yellow;
            }
            {
              name = "Music";
              text = "";
              fg = magenta;
            }
            {
              name = "Pictures";
              text = "";
              fg = yellow;
            }
            {
              name = "Public";
              text = "";
              fg = yellow;
            }
            {
              name = "Videos";
              text = "";
              fg = bright-red;
            }
          ];
          conds = [
            # Special files
            {
              "if" = "orphan";
              text = "";
              fg = yellow;
            }
            {
              "if" = "link";
              text = "";
              fg = base05;
            }
            {
              "if" = "block";
              text = "";
              fg = yellow;
            }
            {
              "if" = "char";
              text = "";
              fg = yellow;
            }
            {
              "if" = "fifo";
              text = "";
              fg = yellow;
            }
            {
              "if" = "sock";
              text = "";
              fg = yellow;
            }
            {
              "if" = "sticky";
              text = "";
              fg = yellow;
            }
            {
              "if" = "dummy";
              text = "";
              fg = yellow;
            }

            # Fallback
            {
              "if" = "dir";
              text = "";
              fg = yellow;
            }
            {
              "if" = "exec";
              text = "";
              fg = bright-red;
            }
            {
              "if" = "!dir";
              text = "";
              fg = base07;
            }
          ];
          prepend_conds = [
            # Hidden directories
            {
              "if" = "hidden & dir";
              text = "󱞞";
            }
          ];
        };
      };
    };
}
