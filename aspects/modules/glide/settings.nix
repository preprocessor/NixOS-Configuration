{
  exo.mods.desktop =
    { lib, scheme, ... }:
    {
      my.glide-browser = {
        enable = true;
        setAsDefaultBrowser = true;
        policies =
          let
            mkLockedAttrs = lib.mapAttrs (
              _: value: {
                Value = value;
                Status = "locked";
              }
            );
          in
          {
            AutofillAddressEnabled = false;
            AutofillCreditCardEnabled = false;
            DisableAppUpdate = true;
            DisableFeedbackCommands = true;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableTelemetry = true;
            DontCheckDefaultBrowser = true;
            NoDefaultBookmarks = true;
            OfferToSaveLogins = false;
            PrintingEnabled = false;
            TranslateEnabled = false;
            SupportMenu = false;
            HardwareAcceleration = true;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
            Preferences = mkLockedAttrs {
              "media.hardware-video-decoding.force-enabled" = true;
              "media.rdd-ffmpeg.enabled" = true;
              "media.av1.enabled" = true;
              "gfx.x11-egl.force-enabled" = false;
              "widget.dmabuf.force-enabled" = true;

              "browser.tabs.warnOnClose" = false;
              "browser.aboutConfig.showWarning" = false;

              "xpinstall.signatures.required" = false;
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

              "gfx.webrender.all" = true;

              "privacy.resistFingerprinting" = true;
              "privacy.resistFingerprinting.randomization.canvas.use_siphash" = true;
              "privacy.resistFingerprinting.randomization.daily_reset.enabled" = true;
              "privacy.resistFingerprinting.randomization.daily_reset.private.enabled" = true;
              "privacy.resistFingerprinting.block_mozAddonManager" = true;
              "privacy.spoof_english" = 1;

              "network.http.http3.enabled" = true;
              "network.socket.ip_addr_any.disabled" = true;

              "widget.use-xdg-desktop-portal.file-picker" = 1;

              "mousebutton.4th.enabled" = false;
              "mousebutton.5th.enabled" = false;
              "middlemouse.paste" = false;
            };
            ExtensionSettings =
              {
                "uBlock0@raymondhill.net" = "ublock-origin";
              }
              |> lib.mapAttrs (
                _: slug: {
                  install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
                  installation_mode = "force_installed";
                }
              );
          };
        profiles.default = {
          isDefault = true;

          textfox = with scheme.withHashtag; {
            enable = true;
            background = {
              color = base11;
            };
            border = {
              color = orange;
              width = "1px";
              transition = "1.0s ease";
              radius = "0";
            };
            displayWindowControls = false;
            displayNavButtons = true;
            displayUrlbarIcons = true;
            displaySidebarTools = false;
            displayTitles = false;
            font = {
              size = "15px";
            };
            tabs = {
              vertical.enable = true;
            };
            navbar = {
              margin = "8px 8px 2px";
              padding = "4px";
            };
            bookmarks = {
              alignment = "left";
            };
            icons = {
              toolbar.extensions.enable = true;
              context.extensions.enable = true;
              context.firefox.enable = true;
            };
            textTransform = "uppercase";
            # extraConfig = "/* custom css here */";
          };
        };
      };
    };
}
