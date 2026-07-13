{
  exo.core =
    { scheme, ... }:
    {
      my.yazi = {
        flavorContent = with scheme.withHashtag; /* toml */ ''
          [mgr]
          cwd = { fg = "${base05}" }

          find_keyword = { fg = "${bright-red}", bold = true, italic = true, underline = true }
          find_position = { fg = "${bright-red}", bold = true, italic = true }

          marker_copied = { fg = "${magenta}", bg = "${magenta}" }
          marker_cut = { fg = "${magenta}", bg = "${magenta}" }
          marker_marked = { fg = "${bright-red}", bg = "${bright-red}" }
          marker_selected = { fg = "${bright-magenta}", bg = "${bright-magenta}" }

          count_copied = { fg = "${base07}", bg = "${magenta}" }
          count_cut = { fg = "${base07}", bg = "${magenta}" }
          count_selected = { fg = "${base11}", bg = "${bright-magenta}" }

          border_style  = { fg = "${base05}" }

          [indicator]
          padding = { open = "▐", close = "▌" }
          parent = {fg = "${base11}", bg = "${yellow}"}
          current = {fg = "${base11}", bg = "${bright-yellow}"}

          [status]
          overall = {  bg = "${base10}", fg = "${bright-blue}" }
          sep_left  = { open = "", close = "" }
          sep_right = { open = "", close = "" }

          progress_label = { bold = true }
          progress_normal = { fg = "${bright-blue}", bg = "${base00}" }
          progress_error = { fg = "${bright-red}", bg = "${base00}" }

          perm_type = { fg = "${bright-blue}" }
          perm_write = { fg = "${bright-magenta}" }
          perm_exec = { fg = "${bright-red}" }
          perm_read = { fg = "${magenta}" }
          perm_sep = { fg = "${bright-blue}" }

          [mode]
          normal_main = { bg = "${bright-cyan}", fg = "${base11}", bold = true }
          normal_alt  = { bg = "${base02}", fg = "${base04}" }

          select_main = { bg = "${yellow}", fg = "${base01}", bold = true }
          select_alt  = { bg = "${base02}", fg = "${base04}" }

          unset_main = { bg = "${bright-magenta}", fg = "${base10}", bold = true }
          unset_alt  = { bg = "${base02}", fg = "${base04}" }


          [input]
          border = { fg = "${bright-blue}" }
          title = {}
          value = { fg = "${base05}" }
          selected = { reversed = true }

          [tabs]
          active = { fg = "${base00}", bold = true, bg = "${yellow}" }
          inactive = { fg = "${yellow}", bg = "${base00}" }
          sep_inner = { open = "", close = "" }
          sep_outer = { open = "", close = "" }

          [cmp]
          border = { fg = "${bright-blue}", bg = "${base11}" }

          [tasks]
          border = { fg = "${bright-blue}" }
          title = {}
          hovered = { fg = "${magenta}", underline = true }

          [which]
          cols = 3
          mask = { bg = "${base00}" }
          cand = { fg = "${bright-blue}" }
          rest = { fg = "${base11}" }
          desc = { fg = "${base05}" }
          separator = " ▶ "
          separator_style = { fg = "${base05}" }

          [spot]
          border   = { fg = "${bright-blue}" }
          title    = { fg = "${bright-blue}" }
          tbl_col  = { fg = "${base05}" }
          tbl_cell = { fg = "${base05}", bg = "${base00}" }

          [help]
          on = { fg = "${base05}" }
          run = { fg = "${base05}" }
          hovered = { reversed = true, bold = true }
          footer = { fg = "${base01}", bg = "${bright-blue}" }

          [notify]
          title_info = { fg = "${bright-magenta}" }
          title_warn = { fg = "${bright-blue}" }
          title_error = { fg = "${bright-red}" }

          [filetype]

          rules = [
              { mime = "image/*", fg = "${bright-cyan}" },
              { mime = "{audio,video}/*", fg = "${bright-yellow}" },
              { mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}", fg = "${bright-magenta}" },
              { mime = "application/{pdf,doc,rtf}", fg = "${green}" },
              { mime = "*", is = "orphan", fg = "${red}", bg = "${brown}" },
              { mime = "application/*exec*", fg = "${bright-red}" },
              { url = "*", fg = "${base05}" },
              { url = "*/", fg = "${base05}" },
          ]

          [icon]
          globs = []
          dirs  = [
          	{ name = ".config", text = "", fg = "${yellow}" },
          	{ name = ".git", text = "", fg = "${yellow}" },
          	{ name = ".github", text = "", fg = "${yellow}" },
          	{ name = ".npm", text = "", fg = "${yellow}" },
          	{ name = "Desktop", text = "", fg = "${yellow}" },
          	{ name = "Projects", text = "󱀫", fg = "${bright-green}" },
          	{ name = "Repos", text = "󰳐", fg = "${bright-green}" },
          	{ name = "Documents", text = "", fg = "${yellow}" },
          	{ name = "Downloads", text = "", fg = "${yellow}" },
          	{ name = "NixOS", text = "", fg = "${yellow}" },
          	{ name = "Library", text = "", fg = "${yellow}" },
          	{ name = "Movies", text = "", fg = "${yellow}" },
          	{ name = "Music", text = "", fg = "${yellow}" },
          	{ name = "Pictures", text = "", fg = "${yellow}" },
          	{ name = "Public", text = "", fg = "${yellow}" },
          	{ name = "Videos", text = "", fg = "${yellow}" },
          ]
          conds = [
          	# Special files
          	{ if = "orphan", text = "", fg = "${yellow}" },
          	{ if = "link", text = "", fg = "${base05}" },
          	{ if = "block", text = "", fg = "${yellow}" },
          	{ if = "char", text = "", fg = "${yellow}" },
          	{ if = "fifo", text = "", fg = "${yellow}" },
          	{ if = "sock", text = "", fg = "${yellow}" },
          	{ if = "sticky", text = "", fg = "${yellow}" },
          	{ if = "dummy", text = "", fg = "${yellow}" },

          	# Fallback
          	{ if = "dir", text = "", fg = "${yellow}" },
          	{ if = "exec", text = "", fg = "${bright-red}" },
          	{ if = "!dir", text = "", fg = "${base07}" },
          ]
          prepend_conds = [
            { if = "hidden & dir",  text = "󱞞" },  # Hidden directories
          ]
        '';
      };
    };
}
