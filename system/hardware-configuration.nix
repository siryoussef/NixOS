# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, systemSettings, ... }:

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

  fileSystems."/" =
    { device = "/dev/disk/by-label/NRoot";
      fsType = "btrfs";
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-label/Nix";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/Boot";
      fsType = "btrfs";
      options = [ "subvol=@Nix" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-label/NHome";
      fsType = "btrfs";
    };

  fileSystems."/Volume" =
    { device = "/dev/disk/by-label/Volume";
      fsType = "auto";
    };

  fileSystems."/Shared" =
    { device = "/dev/disk/by-label/Shared";
      fsType = "auto";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-label/BEFI";
      fsType = "vfat";
    };

boot.loader.efi.efiSysMountPoint = systemSettings.bootMountPath; # does nothing if running bios rather than uefi
swapDevices = [ { device = "/dev/disk/by-label/NixSwap"; } ];

  ## Bind Mounts

  fileSystems."/etc/nixos" =
    { device = "/Shared/@Repo/nixos";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/home/youssef/Downloads" =
    { device = "/Volume/@Storage/Downloads";
      options = ["bind"];
      depends = [ "/" "/home" "/Volume"];
    };

  fileSystems."/home/youssef/.floorp" =
    { device = "/Shared/@Home/.floorp";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/home/youssef/.vscode" =
    { device = "/Shared/@Home/.vscode";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/home/youssef/.local/share/fish" =
    { device = "/Shared/@Home/fish";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/home/youssef/.config/GitHub Desktop" =
    { device = "/Shared/@Home/.config/GitHub Desktop";
      fsType = "none";
      options = [ "bind" ];
    };

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
