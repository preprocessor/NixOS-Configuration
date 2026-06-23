{
  w.default =
    { scheme, ... }:
    {
      wrappers.eza = {
        enable = true;
        settings = with scheme.withHashtag; {
          colourful = true;

          filekinds = {
            normal.foreground = base05;
            directory.foreground = base0A;
            symlink.foreground = base0D;
            pipe.foreground = base04;
            block_device.foreground = base08;
            char_device.foreground = base08;
            socket.foreground = base04;
            special.foreground = base0E;
            executable.foreground = bright-red;
            mount_point.foreground = base0C;
          };

          file_type = {
            image.foreground = base0A;
            video.foreground = base08;
            music.foreground = base0B;
            lossless.foreground = base0C;
            crypto.foreground = base03;
            document.foreground = base05;
            compressed.foreground = base0E;
            temp.foreground = base08;
            compiled.foreground = base0D;
            source.foreground = base0D;
          };

          perms = {
            user_read = {
              foreground = base08;
              is_bold = true;
            };
            user_write = {
              foreground = base0A;
              is_bold = true;
            };
            user_execute_file = {
              foreground = base0B;
              is_bold = true;
            };
            user_execute_other = {
              foreground = base0B;
              is_bold = true;
            };
            group_read.foreground = base08;
            group_write.foreground = base0A;
            group_execute.foreground = base0B;
            other_read.foreground = base08;
            other_write.foreground = base0A;
            other_execute.foreground = base0B;
            special_user_file.foreground = base0E;
            special_other.foreground = base03;
            attribute.foreground = base04;
          };
          size = {
            major.foreground = base05;
            minor.foreground = base0C;
            number_byte.foreground = base04;
            number_kilo.foreground = base05;
            number_mega.foreground = base0D;
            number_giga.foreground = base0E;
            number_huge.foreground = base0E;
            unit_byte.foreground = base05;
            unit_kilo.foreground = base0C;
            unit_mega.foreground = base0E;
            unit_giga.foreground = base0E;
            unit_huge.foreground = base0C;
          };
          users = {
            user_you.foreground = base05;
            user_root.foreground = base08;
            user_other.foreground = base08;
            group_yours.foreground = base05;
            group_other.foreground = base04;
            group_root.foreground = base08;
          };
          links = {
            normal.foreground = base0D;
            multi_link_file.foreground = base0D;
          };
          git = {
            new.foreground = base0B;
            modified.foreground = base0A;
            deleted.foreground = base08;
            renamed.foreground = base0C;
            typechange.foreground = base0E;
            ignored.foreground = base03;
            conflicted.foreground = base09;
          };
          git_repo = {
            branch_main.foreground = base05;
            branch_other.foreground = base0E;
            git_clean.foreground = base0B;
            git_dirty.foreground = base08;
          };
          security_context = {
            colon.foreground = base02;
            user.foreground = base03;
            role.foreground = base0E;
            typ.foreground = base02;
            range.foreground = base0E;
          };
          punctuation.foreground = base02;
          date.foreground = base0A;
          inode.foreground = base05;
          blocks.foreground = base02;
          header.foreground = base05;
          octal.foreground = base0C;
          flags.foreground = base0E;
          symlink_path.foreground = base0C;
          control_char.foreground = base0D;
          broken_symlink.foreground = base08;
          broken_path_overlay.foreground = base02;
        };
      };

      _file = ./settings.nix;
    };
}
