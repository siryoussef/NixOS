# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, systemSettings, userSettings, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "usbhid" "ehci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" "btrfs"];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = ["btrfs" "ntfs"];
  boot.loader.grub.useOSProber = true;

  fileSystems = {
    "/" = { device = "/dev/disk/by-label/NRoot"; fsType = "btrfs"; };
    "/nix" = { device = "/dev/disk/by-label/Nix"; fsType = "ext4"; };
    "/boot" = { device = "/dev/disk/by-label/Boot"; fsType = "btrfs"; options = [ "subvol=@Nix" ]; };
    "/home" = { device = "/dev/disk/by-label/NHome"; fsType = "btrfs"; };
    "/Volume" = { device = "/dev/disk/by-label/Volume"; fsType = "auto"; };
    "/Shared" = { device = "/dev/disk/by-label/Shared"; fsType = "auto"; };
    "/boot/efi" = { device = "/dev/disk/by-label/BEFI"; fsType = "vfat"; };
  ## Bind Mounts
    "/etc/nixos" = { device = "/Shared/@Repo/NixOS"; fsType = "none"; options = [ "bind" ]; };
    "Downloads" = { mountpoint = "/home/"+userSettings.username+"/Downloads"; device = "/Volume/@Storage/Downloads"; options = ["bind"]; depends = [ "/" "/home" "/Volume"]; };
    "floorp"= { mountpoint = "/home/"+userSettings.username+"/.floorp"; device = "/Shared/@Home/.floorp"; fsType = "none"; options = [ "bind" ]; };
    "vscode"= { mountpoint = "/home/"+userSettings.username+"/.vscode"; device = "/Shared/@Home/.vscode"; fsType = "none"; options = [ "bind" ]; };
    "fish"= { mountpoint = "/home/"+userSettings.username+"/.local/share/fish"; device = "/Shared/@Home/fish"; fsType = "none"; options = [ "bind" ]; };
    "Github"={ mountpoint = "/home/"+userSettings.username+"/.config/GitHub Desktop"; device = "/Shared/@Home/.config/GitHub Desktop"; fsType = "none"; options = [ "bind" ]; };
   "GitRepos" ={ mountpoint = "/home/"+userSettings.username+"/Documents/GitHub"; device = "/Shared/@Repo"; fsType = "none"; options = [ "bind" ]; };
  };

boot.loader.efi.efiSysMountPoint = systemSettings.bootMountPath; # does nothing if running bios rather than uefi
swapDevices = [ { device = "/dev/disk/by-label/NixSwap"; } ];
#   btrfs = { autoScrub = { enable = true; interval = "monthly"; fileSystems = [ "/Volume" ]; }; };


  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave"; #wasn't there by default
}
