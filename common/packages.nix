{
  inputs,
  config,
  pkgs,
  ...
}:
{
  # Enable the GNOME Desktop Environment.
  services.desktopManager.gnome.enable = true;

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "colormix";
      bigclock = "en";
      bigclock_12hr = true;
      numlock = true;
      box_title = " Login ";
    };
  };

  programs = {
    niri.enable = true;
    bash.enable = true;
    fish.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnome-extension-manager
    brightnessctl
    imagemagick
    victor-mono
    nixos-shell
    trash-cli
    fastfetch
    fira-code
    ripgrep
    rmtrash
    lazygit
    neovim
    nixfmt
    unzip
    just
    wget
    btop
    bat
    eza
    zip
    git
    fd
  ];
}
