{ config, pkgs, ... }:

{

  ##########################################
  # Import Hardware Configuration          #
  ##########################################
  imports = [
    ./hardware-configuration.nix
  ];

  ##########################################
  # Garbage Collection                     #
  ##########################################
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  ##########################################
  # ZRAM                                   #
  ##########################################
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
  };

  ##########################################
  # Allow Unfree Packages                  #
  ##########################################
  nixpkgs.config.allowUnfree = true;

  ##########################################
  # Boot loader                            #
  ##########################################
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
  }; 

  boot.loader.efi.canTouchEfiVariables = true;

  ##########################################
  # Locale (Ireland )                      #
  ##########################################
  time.timeZone = "Europe/Dublin";
 
  i18n.defaultLocale = "en_IE.UTF-8";
  
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  console.keyMap = "ie";

  services.xserver.xkb = {
    layout = "ie";
    variant = "";
  };

  ##########################################
  # Networking                             #
  ##########################################
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  ##########################################
  # Desktop (Plasma 6)                     #
  ##########################################
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  ##########################################
  # Audio (Modern)                         #
  ##########################################
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  ##########################################
  # Intel CPU / microcode                  #
  ##########################################
  hardware.cpu.intel.updateMicrocode = true;

  ##########################################
  # Intel GPU (UHD 620 tweaks)             #
  ##########################################
  boot.kernelParams = [
    "i915.enable_psr=1"
    "i915.enable_fbc=1"
  ];
  
  ##########################################
  # Power (Simple Modern Approach          #
  ##########################################
  services.power-profiles-daemon.enable = true;

  ##########################################
  # User                                   #
  ##########################################
  users.users.cyb3r = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  ##########################################
  # Packages                               #
  ##########################################
  environment.systemPackages = with pkgs; [
    firefox
    vim
    nano
    vscode
    htop
    curl
    wget
    python3
    gcc
    gdb
    xdg-user-dirs
    obs-studio
    man-db
    man-pages
    texinfo
    efibootmgr
    alacritty
  ];

  fonts.packages = with pkgs; [
    dejavu_fonts
    liberation_ttf
    noto-fonts
    noto-fonts-color-emoji
  ];

  ##########################################
  # Time Sync                              #
  ##########################################
  services.timesyncd.enable = true;

  ##########################################
  # Firewall                               #
  ##########################################
  networking.firewall.enable = true;
  
  ##########################################
  # System Version                         #
  ##########################################
  system.stateVersion = "25.11";

}

