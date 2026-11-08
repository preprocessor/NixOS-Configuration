{
  exo.mods.neovim = { pkgs, ... }: {
    plugins.lsp.servers.qmlls = {
      enable = true;
      package = pkgs.qt6.qtdeclarative;
      extraOptions = {
        cmd = [
          "${pkgs.qt6.qtdeclarative}/bin/qmlls"
          "-E"
          "-I"
          "${pkgs.qt6.qtdeclarative}/lib/qt-6/qml"
          "-I"
          "${pkgs.qt6.qtdeclarative}/${pkgs.qt6.qtbase.qtQmlPrefix}"
          "-I"
          "${pkgs.quickshell}/lib/qt-6/qml"
        ];
        filetypes = [ "qml" ];
        autostart = true;
        settings.qml.formatOnSave = true;
        on_attach = {
          __raw = ''
            function(client, bufnr)
              client.server_capabilities.semanticTokensProvider = nil
            end
          '';
        };
      };
    };
  };

}
