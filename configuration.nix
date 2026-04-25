{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    useOSProber = true;
  };

  boot.loader.canTouchEfiVariables = true;
  
  networking.networkmanager.enable = true;

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

  nixpkgs.config.allowUnfree = true;

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.videoDrivers = [ "modesetting" ];

  hardware.graphics.enable = true;

  environment.systemPackages = with pkgs:
  [
    vscode
    git
    wget
    curl
    python
    nodejs
    npm
  ];

  programs.firefox.enable = true;

  users.users.cyber = {
    isNormalUser = true;
    description = "CYB3R"
    extraGroups = [ "networkmanager" "wheel" ];
  };
 
  system.stateVersion = 25.11;
}
