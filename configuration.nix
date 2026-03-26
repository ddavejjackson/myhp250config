# /etc/nixos/configuration.nix
{ config, pkgs, ... }:

{
  #################################################################
  # Bootloader (GRUB, UEFI)
  #################################################################
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = true;

  #################################################################
  # Hostname / Locale / Keyboard
  #################################################################
  networking.hostName = "nixos-hp250";
  time.timeZone = "Europe/Dublin";  
  i18n.defaultLocale = "en_IE.UTF-8";
  console.keyMap = "ie";

  #################################################################
  # Users
  #################################################################
  users.users.youruser = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" ];
    password = "changeme";  # change after installation
  };

  #################################################################
  # Networking
  #################################################################
  networking.networkmanager.enable = true;

  #################################################################
  # Swap and ZRAM
  #################################################################
  boot.kernelModules = [ "zram" ];
  swapDevices = [
    { device = "zram0"; size = 12288; } # 12GB ZRAM
  ];

  #################################################################
  # X11 / Plasma 6 Desktop
  #################################################################
  services.xserver.enable = true;
  services.xserver.layout = "ie";
  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.displayManager.sddm.enable = true;

  # Plasma 6 desktop session
  services.xserver.desktopManager.plasma5.enable = false; # disable Plasma 5

  environment.systemPackages = with pkgs; [
    plasma-unified            # Plasma 6 session
    kdeApplications.konsole
    kdeApplications.kate
    kdeApplications.dolphin
    kdeApplications.kcalc
    kdeApplications.okular
    breeze
    breeze-icons
    tela-icon-theme          # modern icon set
    noto-fonts               # clean font support
    arc-theme                # optional modern GTK theme for apps
  ];

  #################################################################
  # Intel GPU tweaks
  #################################################################
  boot.kernelParams = [
    "i915.enable_psr=1"   # Panel Self Refresh (power saving)
    "i915.enable_dc=1"    # Display C-state (power saving)
    "i915.enable_guc=3"   # GuC submission and HuC loading (performance)
    "i915.alpha_support=1" # enable experimental features
  ];

  #################################################################
  # Laptop Power Management (TLP)
  #################################################################
  services.tlp.enable = true;
  services.tlp.defaultCpuGovernor = "powersave";
  services.tlp.enableUsbAutosuspend = true;
  services.tlp.enableBatteryCare = true;

  # Automatic performance/power profiles
  hardware.cpu.intel.updateMicrocode = true;
  services.tlp.extraConfig = ''
    # Aggressive power saving when on battery
    DISK_IDLE_SECS_ON_BAT=5
    PCIE_ASPM_ON_BAT=powersupersave
    # Performance on AC
    CPU_SCALING_GOVERNOR_ON_AC=performance
  '';

  #################################################################
  # Touchpad / Input
  #################################################################
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.enable = true;
  services.xserver.libinput.touchpad.tapToClick = true;
  services.xserver.libinput.touchpad.naturalScrolling = true;
  services.xserver.libinput.touchpad.disableWhileTyping = true;

  #################################################################
  # Screen brightness auto-adjust
  #################################################################
  hardware.backlight = {
    enable = true;
    defaultBrightness = 50; # default on boot
  };

  #################################################################
  # Sound
  #################################################################
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  #################################################################
  # Filesystems (adjust labels as needed)
  #################################################################
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
  };

  #################################################################
  # Networking / Security
  #################################################################
  networking.firewall.enable = true;
  services.openssh.enable = true;

  #################################################################
  # Nix & Flakes
  #################################################################
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  #################################################################
  # KDE tweaks / session
  #################################################################
  environment.variables.KDE_FULL_SESSION = "true";
  environment.variables.KDE_AUTO_SCREEN_SCALE_FACTOR = "1"; # scaling fix for HiDPI
  services.kde.plasma5.enableCompositor = true;
}
