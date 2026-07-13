{
  exo.mods.desktop =
    {
      scheme,
      config,
      lib,
      ...
    }:
    {
      hj.xdg.mime-apps.default-applications = {
        "x-scheme-handler/discord" = [ "vesktop.desktop" ];
      };

      my.hyprland.startup =
        let
          cfg = config.my.vesktop;
        in
        [ /* lua */ ''hl.exec_cmd("${lib.getExe cfg.package}", { workspace = "name:chat silent" })'' ];

      my.hyprland.lua.files."window_rules.vesktop".content = /* lua */ ''
        hl.window_rule({
          name = "hide vesktop",
          match = { class = "^vesktop$" },
          workspace = "name:chat silent",
          tag = "+hidden"
        })
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
        };
      };
    };
}
