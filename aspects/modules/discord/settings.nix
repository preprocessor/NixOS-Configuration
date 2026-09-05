{
  exo.mods.comms =
    {
      scheme,
      config,
      lib,
      ...
    }:
    {
      my.hyprland.startup =
        let
          cfg = config.my.vesktop;
        in
        [ /* lua */ ''hl.exec_cmd("${lib.getExe cfg.package}", { workspace = "name:chat silent" })'' ];

      my.hyprland.windowrules.vesktop = [
        {
          name = "hide vesktop";
          match.class = "^vesktop$";
          rules = {
            workspace = "name:chat silent";
            tag = "+hidden";
          };
        }
      ];

      my.hyprland.lua.files."keybinds/vesktop".content = /* lua */ ''
        hl.bind("SUPER + F1", hl.dsp.send_shortcut({ mods = "CTRL + SHIFT", key = "M", window = "class:(vesktop)" }))
      '';

      my.vesktop = with scheme.withHashtag; {
        enable = true;

        settings = {
          appBadge = false;
          arRPC = true;
          disableMinSize = true;
          enableSplashScreen = false;
          hardwareAcceleration = true;
          hardwareVideoAcceleration = true;
          discordBranch = "stable";
          autoStartMinimized = false;
          customTitleBar = false;
          splashBackground = base00;
          splashColor = base05;
          splashTheming = true;
        };

        vencord.settings = {
          autoUpdate = false;
          autoUpdateNotification = false;
          notifyAboutUpdates = false;
          eagerPatches = false;
          enabledThemes = [ ];
          enableReactDevtools = false;
          frameless = false;
          transparent = false;
          winCtrlQ = false;
          disableMinSize = false;
          winNativeTitleBar = false;

          plugins = {
            AlwaysExpandRoles.enabled = true;
            BetterRoleContext.enabled = true;
            BadgeAPI.enabled = true;
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
            FixCodeblockGap.enabled = true;
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
            NoTrack = {
              enabled = true;
              disableAnalytics = true;
            };
            Settings = {
              enabled = true;
              settingsLocation = "aboveNitro";
            };
            DisableDeepLinks.enabled = true;
            SupportHelper.enabled = true;
            WebContextMenus.enabled = true;
          };
        };
      };
    };
}
