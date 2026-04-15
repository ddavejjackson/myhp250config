{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.11";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "hp250g7";

  # Networking
  networking.networkmanager.enable = true;

  # Time zone and locale
  time.timeZone = "Europe/Dublin";
  i18n.defaultLocale = "en_IE.UTF-8";

  # Keyboard layout
  services.xserver.xkb = {
    layout = "ie";
    variant = "";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Graphics
  hardware.graphics.enable = true;

  # Desktop environment
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  # Audio
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Power management
  services.power-profiles-daemon.enable = true;

  # Git
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      # Set these to your actual details
      user.name = "Your Name";
      user.email = "you@example.com";
    };
  };

  # Docker
  virtualisation.docker.enable = true;

  # VirtualBox host
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };

  # User account
  users.users.cyb3r = {
    isNormalUser = true;
    description = "Cyb3r";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "vboxusers"
    ];
  };

  # Packages
  environment.systemPackages = with pkgs; [
    wget
    curl
    vim
    htop
    unzip

    google-chrome
    vscode
    virtualbox
  ];

  # Enable flakes and modern nix commands
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Firewall
  networking.firewall.enable = true;

  # Sudo
  security.sudo.enable = true;
}
