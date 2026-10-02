{
  exo.mods.gaming = {
    # Disable DS5 touchpad
    services.udev.extraRules = ''
      # USB Connection
      ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      # Bluetooth Connection
      ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';
  };
}
