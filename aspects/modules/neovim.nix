{
  inputs.neovim = {
    url = "path:/home/wyspr/Configuration/Neovim/";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  w.default =
    {
      constants,
      packages',
      pkgs,
      lib,
      ...
    }:
    {
      environment.variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };

      hj.packages = [
        packages'.neovim
        (pkgs.writeShellScriptBin "mdvim" (lib.getExe packages'.neovim.mdvim))
        (pkgs.writeShellScriptBin "todo" "${lib.getExe packages'.neovim.mdvim} ${constants.homedir}/todo.md")
      ];

      hj.xdg.mime-apps.default-applications = {
        "text/*" = [ "nvim.desktop" ];
      };

      custom.xdg.desktopEntries = {
        nvim = {
          noDisplay = true;
          exec = "nvim %F";
          terminal = true;
          type = "Application";
          startupNotify = false;
          mimeType = [
            "text/english"
            "text/plain"
            "text/x-makefile"
            "text/x-c++hdr"
            "text/x-c++src"
            "text/x-chdr"
            "text/x-csrc"
            "text/x-java"
            "text/x-moc"
            "text/x-pascal"
            "text/x-tcl"
            "text/x-tex"
            "application/x-shellscript"
            "text/x-c"
            "text/x-c++"
          ];
          settings = {
            TryExec = "nvim";
          };
        };
      };
    };

}
