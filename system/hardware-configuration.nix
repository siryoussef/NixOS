# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, modulesPath, systemSettings, userSettings, ... }:
let
DiscMounts ={
    "/" = { device = "none"; fsType = "tmpfs"; }; # In-RAM-Root
#     "/" = { device = "/dev/disk/by-label/NRoot"; fsType = "btrfs"; };
    "/nix" = { device = "/dev/disk/by-label/Nix"; fsType = "ext4"; depends = ["/" "/home"];};
    "/boot" = { device = "/dev/disk/by-label/Boot"; fsType = "btrfs"; options = [ "subvol=@Nix" ]; };
    "/home" = { device = "/dev/disk/by-label/Home"; fsType = "btrfs"; options =["subvol=@NHome"];};
#     "/home" = { device = "none"; fsType = "tmpfs"; options = ["rw" "user"]; }; # In-RAM-Home
    "/Volume" = { device = "/dev/disk/by-label/Volume"; fsType = "auto"; };
    "/Shared" = { device = "/dev/disk/by-label/Shared"; fsType = "auto"; };
    "/boot/efi" = { device = "/dev/disk/by-label/BEFI"; fsType = "vfat"; };
     };

## Overlayfs

#   merged = (lib.recursiveUpdate DiscMounts BindMounts);
fileSystems = DiscMounts;

in{ inherit fileSystems;
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];
  boot = {
    initrd = { availableKernelModules = [ "xhci_pci" "usbhid" "ehci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" "btrfs"]; kernelModules = [ "dm-snapshot" ]; };
    kernelParams = ["DP-2=1280x1024"];
    kernelModules = [ "kvm-intel" "i2c-dev" "i2c-piix4" "cpufreq_powersave"];
    extraModulePackages = [ ];
    supportedFilesystems = ["vfat" "ext4" "btrfs" "ntfs"];
    loader = { grub.useOSProber = true; efi.efiSysMountPoint = systemSettings.bootMountPath; # does nothing if running bios rather than uefi
      };
  };


swapDevices = [ { device = "/dev/disk/by-label/NixSwap"; } ];
#   btrfs = { autoScrub = { enable = true; interval = "monthly"; fileSystems = [ "/Volume" ]; }; };


  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.graphics.enable = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave"; #wasn't there by default
}
