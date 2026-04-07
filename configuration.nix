{ config, pkgs, ... }:

{
  ##########################################
  # Imports
  ##########################################
  imports = [
    ./hardware-configuration.nix
  ];

  ##########################################
  # System Version
  ##########################################
  system.stateVersion = "25.11";

  ##########################################
  # Nix Settings
  ##########################################
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;

  ##########################################
  # Bootloader (UEFI + GRUB)
  ##########################################
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
    };
    efi.canTouchEfiVariables = true;
  };

  ##########################################
  # Kernel / Intel GPU tweaks
  ##########################################
  boot.kernelParams = [
    "i915.enable_psr=2"
    "i915.enable_fbc=1"
    "i915.fastboot=1"
  ];

  ##########################################
  # Locale & Time
  ##########################################
  time.timeZone = "Europe/Dublin";

  i18n = {
    defaultLocale = "en_IE.UTF-8";
    extraLocaleSettings = {
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
  };

  console.keyMap = "ie";

  ##########################################
  # X11 / Keyboard
  ##########################################
  services.xserver = {
    enable = true;
    xkb.layout = "ie";
  };

  ##########################################
  # KDE Plasma 6 (Wayland)
  ##########################################
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.desktopManager.plasma6.enable = true;

  ##########################################
  # Networking
  ##########################################
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    networkmanager.wifi.powersave = false;
    firewall.enable = true;
  };

  ##########################################
  # Audio (PipeWire)
  ##########################################
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  ##########################################
  # Hardware (Modern 25.11 way)
  ##########################################
  hardware = {
    cpu.intel.updateMicrocode = true;

    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libvdpau-va-gl
      ];
    };
  };

  ##########################################
  # Power Management
  ##########################################
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;

  ##########################################
  # ZRAM (Better memory usage)
  ##########################################
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
  };

  ##########################################
  # Time Sync
  ##########################################
  services.timesyncd.enable = true;

  ##########################################
  # User
  ##########################################
  users.users.cyb3r = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  ##########################################
  # Fonts
  ##########################################
  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      liberation_ttf
      noto-fonts
      noto-fonts-color-emoji
      jetbrains-mono
    ];

    fontconfig.defaultFonts = {
      sansSerif = [ "Noto Sans" ];
      monospace = [ "JetBrains Mono" ];
    };
  };

  ##########################################
  # System Packages
  ##########################################
  environment.systemPackages = with pkgs; [
    # Editors / Dev
    vim
    nano
    vscode
    gcc
    gdb
    python3
    nodejs

    # CLI tools
    htop
    curl
    wget

    # Desktop apps
    firefox
    alacritty
    obs-studio

    # KDE apps
    kdePackages.kate
    kdePackages.konsole
    kdePackages.dolphin
    kdePackages.kdeconnect-kde

    # System tools
    xdg-user-dirs
    efibootmgr

    # Docs
    man-db
    man-pages
    texinfo

    # Office Related
    libreoffice-fresh
    obsidian

    # VPN
    openvpn

    # Theming (Windows 11 for familiarity)
    kdePackages.kde-gtk-config
    candy-icons
    sweet
    sweet-nova

    unzip
    tar
  ];

  ##########################################
  # Optional Realtek Fix (if needed)
  ##########################################
  # boot.extraModprobeConfig = ''
  #   options rtw88_pci disable_aspm=1
  # '';
}
