{ inputs, pkgs, ... }:
{
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "colormix";
      bigclock = "en";
      bigclock_12hr = true;
      numlock = true;
      box_title = " Login ";

      # colormix_col1 = 0x00FF0000
      # colormix_col2 = 0x000000FF
      # colormix_col3 = 0x20000000
    };
  };

  programs = {
    niri.enable = true;
    bash.enable = true;
    fish.enable = true;
    neovim.defaultEditor = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.rocmSupport = true;

  systemd.user.services.polkit-agent = {
    description = "PolicyKit Authentication by Gnome";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    with pkgs;
    let
      flakePkg = src: name: inputs.${src}.packages.x86_64-linux.${name};
    in
    [
      # (flakePkg "hevel" "hevel")
      # (flakePkg "hevel" "wld")
      # (flakePkg "hevel" "swc")
      # (flakePkg "hevel" "swall")

      (flakePkg "river" "river")
      (flakePkg "river" "rill")
      (flakePkg "river" "canoe")

      brightnessctl
      xwayland-satellite
      imagemagick
      nixos-shell
      quickshell
      trash-cli
      fastfetch
      ripgrep
      rmtrash
      lazygit
      nvim-pkg # neovim
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
