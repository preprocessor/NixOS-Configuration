{
  exo.mods.comms =
    { scheme, ... }:
    {
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

  exo.skeleton =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      json = pkgs.formats.json { };
      cfg = config.my.vesktop;
    in
    {
      options.my.vesktop = {
        enable = lib.mkEnableOption { };

        package = lib.mkPackageOption pkgs "vesktop" { };

        settings = lib.mkOption {
          inherit (json) type;
          description = "Vesktop settings";
          default = { };
        };

        vencord.settings = lib.mkOption {
          inherit (json) type;
          default = { };
          description = "Vencord settings";
        };
      };

      config = lib.mkIf cfg.enable {
        hj.packages = [ cfg.package ];

        hj.xdg.config.files = {
          "vesktop/settings.json".source = json.generate "vesktop-settings" cfg.settings;
          "vesktop/settings/settings.json".source = json.generate "vencord-settings" cfg.vencord.settings;
        };

        hj.xdg.mime-apps.default-applications = {
          "x-scheme-handler/discord" = [ "vesktop.desktop" ];
        };

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

      };
    };
}
