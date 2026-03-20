{
  flake.modules.homeManager.desktop = {
    programs.vesktop = {
      enable = true;
      settings = {
        appBadge = false;
        arRPC = true;
        disableMinSize = true;
        enableSplashScreen = false;
        hardwareAcceleration = true;
        hardwareVideoAcceleration = true;
        discordBranch = "stable";
        tray = false;
        autoStartMinimized = false;
        minimizeToTray = false;
        customTitleBar = false;
      };

      # vencord.themes = {
      #   "${theme.name}" = theme.file;
      # };

      vencord.settings = {
        # enabledThemes = [ "${theme.name}.css" ];
        themeLinks = [
          "https://raw.githubusercontent.com/F0XX00/midnight-everforest-discord/501e9fef6e208cffc4ea68f0c292976d28230fed/midnight-everforest.theme.css"
        ];

        autoUpdate = true;
        autoUpdateNotification = false;
        disableMinSize = true;
        notifyAboutUpdates = false;

        plugins = {
          AlwaysExpandRoles.enabled = true;
          BetterRoleContext.enabled = true;
          BetterSettings.enabled = true;
          BiggerStreamPreview.enabled = true;
          ClearURLs.enabled = true;
          CopyEmojiMarkdown.enabled = true;
          CopyFileContents.enabled = true;
          CopyStickerLinks.enabled = true;
          CopyUserURLs.enabled = true;
          CrashHandler.enabled = true;
          DisableCallIdle.enabled = true;
          FakeNitro.enabled = true;
          ExpressionCloner.enabled = true;
          FriendsSince.enabled = true;
          NoF1.enabled = true;
          NoOnboardingDelay.enabled = true;
          NoUnblockToJump.enabled = true;
          Translate.enabled = true;
          Unindent.enabled = true;
          UnsuppressEmbeds.enabled = true;
          ValidReply.enabled = true;
          ValidUser.enabled = true;
          ViewIcons.enabled = true;
          VolumeBooster.enabled = true;
          YoutubeAdblock.enabled = true;
          WebKeybinds.enabled = true;
          WebScreenShareFixes.enabled = true;
        };

        # useQuickCss = true;
      };
    };
  };
}
