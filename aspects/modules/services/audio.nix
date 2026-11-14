{
  modules.core = {
    # Whether to enable the RealtimeKit system service, which hands out realtime scheduling priority to user processes on demand. For example, PulseAudio and PipeWire use this to acquire realtime priority.
    security.rtkit.enable = true;

    services.pulseaudio.enable = false;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;

      # Custom PipeWire configuration for stability
      extraConfig.pipewire = {
        "99-custom-config" = {
          "context.properties" = {
            # Larger buffers to prevent xruns and stuttering
            "default.clock.rate" = 48000;
            "default.clock.quantum" = 1024;
            "default.clock.min-quantum" = 32;
            "default.clock.max-quantum" = 2048;

            # CPU optimization
            "default.clock.power-of-two-quantum" = true;

            # Memory settings
            "mem.warn-mlock" = false;
            "mem.allow-mlock" = true;
          };
        };
      };

      # Better JACK buffer size for desktop use
      extraConfig.jack = {
        "99-buffer-size" = {
          "jack.properties" = {
            "default.buffer-size" = 1024; # Increased from 128
          };
        };
      };

      # PulseAudio compatibility layer config
      extraConfig.pipewire-pulse = {
        "99-pulse-config" = {
          "pulse.properties" = {
            "pulse.min.req" = "1024/48000";
            "pulse.default.req" = "2048/48000";
            "pulse.max.req" = "4096/48000";
            "pulse.min.frag" = "1024/48000";
            "pulse.default.frag" = "2048/48000";
            "pulse.max.frag" = "4096/48000";
            "pulse.default.tlength" = "4096/48000";
            "pulse.min.quantum" = "1024/48000";
            "pulse.max.quantum" = "2048/48000";
          };
          "stream.properties" = {
            "node.latency" = "1024/48000";
            "resample.quality" = 4;
          };
        };
      };
    };
    # Audio performance limits
    security.pam.loginLimits = [
      {
        domain = "@audio";
        item = "rtprio";
        type = "-";
        value = "95";
      }
      {
        domain = "@audio";
        item = "memlock";
        type = "-";
        value = "unlimited";
      }
      {
        domain = "mmanzanares";
        item = "rtprio";
        type = "-";
        value = "95";
      }
      {
        domain = "mmanzanares";
        item = "memlock";
        type = "-";
        value = "unlimited";
      }
    ];
  };
}
