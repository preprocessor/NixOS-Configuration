{
  w.desktop =
    { pkgs, ... }:
    {
    };

  w.default =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      json = pkgs.formats.json { };
      cfg = config.custom.programs.vesktop;
    in
    {
      options.custom.programs.vesktop = lib.mkOption {
        type = json.type;
        default = { };
        description = "Vesktop settings";
        options = {
          vencord = lib.mkOption {
            type = json.type;
            default = { };
            description = "Vencord settings";
          };
        };
      };

      config = lib.mkIf (cfg != { }) {
        hj.packages = [ pkgs.vesktop ];

        hj.xdg.config.files = {
          "vesktop/settings.json".source = json.generate "vesktop-settings" {
            appBadge = false;
            arRPC = true;
            disableMinSize = true;
            enableSplashScreen = false;
            hardwareAcceleration = true;
            hardwareVideoAcceleration = true;
            discordBranch = "stable";
            autoStartMinimized = false;
            customTitleBar = false;
          };

          "vesktop/settings/settings.json".source = json.generate "vencord-settings" {
            autoUpdate = true;
            autoUpdateNotification = false;
            disableMinSize = true;
            notifyAboutUpdates = false;

            enabledThemes = [
              ""
            ];

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
    };
}
