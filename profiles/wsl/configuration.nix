# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, pkgs, settings, ... }:

with lib;
let
  nixos-wsl = import ./nixos-wsl;
in
{
  imports =
    [ nixos-wsl.nixosModules.wsl
      ../../system/hardware/kernel.nix # Kernel config
      ../../system/hardware/systemd.nix # systemd config
      ../../system/hardware/time.nix # Network time sync
      ../../system/hardware/opengl.nix
      ../../system/hardware/printing.nix
      ../../system/hardware/bluetooth.nix
      ../../system/security/doas.nix
      ../../system/security/gpg.nix
      ../../system/security/blocklist.nix
      ../../system/security/firewall.nix
      ../../system/security/firejail.nix
      ../../system/style/stylix.nix
    ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = settings.user.username;
    startMenuLaunchers = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;

  };

  # Fix nix path
  nix.nixPath = [ "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
                  "nixos-config=$HOME/dotfiles/system/configuration.nix"
                  "/nix/var/nix/profiles/per-user/root/channels"
                ];

  # Experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Ensure nix flakes are enabled
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # I'm sorry Stallman-taichou
  nixpkgs.config.allowUnfree = true;

  # Kernel modules
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" "cpufreq_powersave" ];

  # Networking
  networking.hostName = settings.system.hostname; # Define your hostname.

  # Timezone and locale
  time.timeZone = settings.system.timezone; # time zone
  i18n.defaultLocale = settings.system.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = settings.system.locale;
    LC_IDENTIFICATION = settings.system.locale;
    LC_MEASUREMENT = settings.system.locale;
    LC_MONETARY = settings.system.locale;
    LC_NAME = settings.system.locale;
    LC_NUMERIC = settings.system.locale;
    LC_PAPER = settings.system.locale;
    LC_TELEPHONE = settings.system.locale;
    LC_TIME = settings.system.locale;
  };

  # User account
  users.users.${settings.user.username} = {
    isNormalUser = true;
    description = settings.user.name;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    uid = 1000;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    zsh
    git
    home-manager
  ];

  # I use zsh btw
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # It is ok to leave this unchanged for compatibility purposes
  system.stateVersion = "22.05";

}
