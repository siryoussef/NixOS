{ lib, pkgs, settings, ... }:

{
  imports =
    [ ../../system/hardware-configuration.nix
      ../../system/hardware/time.nix # Network time sync
      ../../system/security/doas.nix
      ../../system/security/gpg.nix
      ( import ../../system/app/docker.nix {storageDriver = "btrfs"; inherit settings pkgs lib;} )
    ];

  # Fix nix path
  nix.nixPath = [ "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
                  "nixos-config=$HOME/dotfiles/system/configuration.nix"
                  "/nix/var/nix/profiles/per-user/root/channels"
                ];

  # Ensure nix flakes are enabled
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # I'm sorry Stallman-taichou
  nixpkgs.config.allowUnfree = true;

  # Kernel modules
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];

  # Bootloader
  # Use systemd-boot if uefi, default to grub otherwise
  boot.loader.systemd-boot.enable = if (settings.system.bootMode == "uefi") then true else false;
  boot.loader.efi.canTouchEfiVariables = if (settings.system.bootMode == "uefi") then true else false;
  boot.loader.efi.efiSysMountPoint = settings.system.bootMountPath; # does nothing if running bios rather than uefi
  boot.loader.grub.enable = if (settings.system.bootMode == "uefi") then false else true;
  boot.loader.grub.device = settings.system.grubDevice; # does nothing if running uefi rather than bios

  # Networking
  networking.hostName = settings.system.hostname; # Define your hostname.
  networking.networkmanager.enable = true; # Use networkmanager

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
    rclone
    rdiff-backup
    cryptsetup
    gocryptfs
  ];

  # I use zsh btw
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # It is ok to leave this unchanged for compatibility purposes
  system.stateVersion = "22.11";

}
