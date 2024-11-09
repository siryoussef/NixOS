# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs', settings, ... }:
let pkgs=pkgs'.main;
in{
  imports =
    [
      ../../system/hardware-configuration.nix
      ../../system/hardware/systemd.nix # systemd config
      ../../system/hardware/kernel.nix # Kernel config
      ../../system/hardware/power.nix # Power management
      ../../system/hardware/time.nix # Network time sync
      ../../system/hardware/printing.nix
      ../../system/hardware/bluetooth.nix
      (./. + "../../../system/wm"+("/"+settings.user.wm)+".nix") # My window manager
      ../../system/app/appsupport.nix
      ../../system/virtualisation/virtualisation.nix
      ../../system/app/syncthing.nix
#       ../../system/app/samba.nix
      ../../system/security.nix
      ../../system/style/stylix.nix
      ../../system/app/sh.nix
      ../../system/app/develop.nix
      ../../secrets/networks.nix
      ../../secrets/hashedPassword.nix
];

  boot = {
  # Kernel modules
  #kernel.enable = true;
    plymouth.enable = true;
    enableContainers = true;
    hardwareScan = true;
  # Bootloader
    loader = {
  # Use systemd-boot if uefi, default to grub otherwise
      systemd-boot.enable = /*if (settings.system.bootMode == "uefi") then true else*/ false;
  efi.canTouchEfiVariables = if (settings.system.bootMode == "uefi") then true else false;
   # Bootloader.
      generationsDir.copyKernels = true;
      timeout = 3;

      grub = {enable = /*if (settings.system.bootMode == "uefi") then false else*/ true;
          device = settings.system.grubDevice; # does nothing if running uefi rather than bios
          efiSupport = true;
          efiInstallAsRemovable = false;
#         zfsSupport = true;
          copyKernels = true;
          default = 0;
#         timeoutStyle = "menu";
          useOSProber = true;
        devices = [ "/dev/disk/by-label/Boot" ];
          };
  };
};
  # Networking

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
users = {
  defaultUserShell = pkgs.fish;
  mutableUsers = false;
  users={
    avahi.uid= 999;
    flatpak.uid=998;
    nm-iodine.uid=997;
    nscd.uid=996;
    rtkit.uid=995;
    systemd-oom.uid=994;
    ${settings.user.username} = {
      isNormalUser = true;
      description = settings.user.name;
      group = "users";
      extraGroups = [ "users" "networkmanager" "wheel" "input" "dialout" "kvm" "qemu-libvirtd" "polkituser" "libvirtd" "vboxusers" "aria2" "syncthing"];
  #     packages = with pkgs; [];
      uid = 1000;
    };
  };
  groups={
    adbusers.gid=999;
    avahi.gid=998;
    flatpak.gid=997;
    jupyter.gid=996;
    lxd.gid=995;
    msr.gid=994;
    nscd.gid=993;
    podman.gid=992;
    polkituser.gid=991;
    rtkit.gid=990;
    sgx_prv.gid=989;
    systemd-coredump.gid=988;
    systemd-oom.gid=987;
    vboxusers.gid=986;
    };
  extraGroups.vboxusers.members = [ settings.user.username ];
};

environment = {
  shells = with pkgs; [ fish zsh bash ];
  sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
#   persistence.${settings.system.persistentStorage} = let storage= import settings.paths.storage{inherit settings config;}; persistent = storage.persistent; in (persistent.system // {users.${settings.user.username}=persistent.user;});
  # List packages installed in system profile.
#   systemPackages = settings.pkglists.work.system;
  };
fonts.fontDir.enable = true;
xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
    ];
  };

#  boot.resumeDevice = "/dev/disk/by-uuid/50ee6795-a53f-f245-a3d0-cfabbfb81097";
#       fsType = "btrfs";
#       options = [ "subvol=swap" ];
#       #mountPoint = "/swap" ;
#       neededForBoot = true;
#       depends = [ ];


#   # Set your time zone.
#   time.timeZone = "Africa/Cairo";
#
#   # Select internationalisation properties.
#   i18n.defaultLocale = "en_US.UTF-8";


/*
i18n.extraLocaleSettings = {
    LANGUAGE = "ar_EG.UTF-8";
    LC_ALL = "ar_EG.UTF-8";
    LC_ADDRESS = "ar_EG.UTF-8";
    LC_IDENTIFICATION = "ar_EG.UTF-8";
    LC_MEASUREMENT = "ar_EG.UTF-8";
    LC_MONETARY = "ar_EG.UTF-8";
    LC_NAME = "ar_EG.UTF-8";
    LC_NUMERIC = "ar_EG.UTF-8";
    LC_PAPER = "ar_EG.UTF-8";
    LC_TELEPHONE = "ar_EG.UTF-8";
    LC_TIME = "ar_EG.UTF-8";
  };

*/

services = {
# Set the keyboard layout.

  emacs = { enable = true; install = true; startWithGraphical = true; defaultEditor = true; };
  upower.enable = true;
  acpid.enable = true;
  btrfs = { autoScrub = { enable = true; interval = "monthly"; fileSystems = [
"/Volume" ]; }; };
  physlock.lockOn.hibernate = true;
  redlib.enable = true;
  onlyoffice.enable = false;
  logind.hibernateKey = "hibernate";
  autosuspend.settings = {
  enable = false;
  interval = 21;
  idle_time = 70;
};
  autosuspend.enable = false;
  blueman.enable = true;
  aria2 = { enable = false; settings.dir = "/Volume/@Storage/Downloads";
            rpcSecretFile = "/Volume/@Storage/Downloads/aria2-rpc-token.txt"; };
  gpm.enable = true;

  thermald.enable = true;
  auto-cpufreq.enable = true;
  #logind.hibernateKey = "hibernate";
  lvm = { enable = true; boot.thin.enable = true; dmeventd.enable = true; };

  # Enable the X11 windowing system.
  xserver = {
  enable = true;
  xkb.layout = "us";
  };
  displayManager.autoLogin = { enable = true; user = settings.user.username; };
  pipewire = {
    enable = true;
    alsa = { enable = true; support32Bit = true; };
    pulse.enable = true;
  };
  logrotate.checkConfig = false;
  #logrotate is disabled due to an error during build
};
  console.useXkbConfig = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable sound with pipewire.
  hardware = {
    pulseaudio.enable = false;
    cpu = { intel = { updateMicrocode = true; sgx.provision.enable = true; };
            x86.msr.enable = true; };
    bluetooth = { enable = true; powerOnBoot = true; };
  };

systemd = {
/*
  services = {
#     "getty@tty1".enable = false;
#     "autovt@tty1".enable = false;

    create-swapfile = { enable = false;
      serviceConfig.Type = "oneshot";
      wantedBy = [ "swap-swapfile.swap" ];
      script = ''
        ${pkgs.coreutils}/bin/truncate -s 0 /swap/swapfile
        ${pkgs.e2fsprogs}/bin/chattr +C /swap/swapfile
        ${pkgs.btrfs-progs}/bin/btrfs property set /swap/swapfile compression none
      '';
    };
  };
  */

  oomd = { enable = true; enableRootSlice = false; enableUserSlices = false;
           enableSystemSlice = false; };

  network.wait-online.enable = false;
#   enableUnifiedCgroupHierarchy = pkgs.lib.mkForce  true; # Legacy > now obsolete
  enableCgroupAccounting = true;
};


  #nixpkgs.overlays = [ (import ./overlays.nix) ];

/*
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

*/

  # firejail

programs = {
  nh={enable=true; clean={enable=true; dates="weekly"; extraArgs="--keep 5 --keep-since 3d";};};
  udevil.enable = true;
  firejail.enable = true;
  captive-browser={enable = false; package=pkgs.captive-browser;};
  partition-manager={enable = true; /*package=pkgs.kdePackages.partitionmanager;*/};
  git={enable = true; prompt.enable=true; /*config =[];*/};
  appimage = { enable = true; binfmt = true;};
  #cfs-zen-tweaks.enable = true;
  fuse.userAllowOther = true;
  nano.syntaxHighlight = true;
  #wayfire.enable = true;
  atop = { enable = true; atopgpu.enable = false; };
  system-config-printer.enable = false;
  java = { enable = true; package = pkgs.jre; binfmt = true; };

  gnupg.agent.pinentryPackage = pkgs.pinentry-qt ;

  tmux.enable = true;
  adb.enable = true;
  waybar.enable = false;
  xwayland.enable = true;
  htop.enable = true;
  darling = { enable = false; package = pkgs.darling;};
  chromium = {
    enable = true;
    homepageLocation = "https://duckduckgo.com";
    defaultSearchProviderEnabled = true;
  };
  command-not-found.enable = false;
  miriway.enable = false;

  kdeconnect = { enable = true; /* package = pkgs.plasma5Packages.kdeconnect-kde; */ };
  droidcam.enable=true;
  singularity = {enable=false; package=pkgs.apptainer; enableFakeroot=true; enableSuid=true; };
  gnome-disks.enable = true;
  };

  appstream.enable = true;
#   qt.style = "adwaita-dark";
#   qt.platformTheme = "kde";
  qt.enable = true;
  gtk.iconCache.enable = true;


  powerManagement.enable = true;
#  documentation.nixos.enable = true;


/*
  zramSwap.swapDevices = 1;
  zramSwap.algorithm = "lz4";
  zramSwap.writebackDevice = "/swap/swapfile";
  swapDevices = [  { device = "/swap/swapfile"; } ];
  zramSwap.enable = false;
*/

  /*
  swapDevices = [
  {
  label = "Swap";
  }
  ];
  */

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system = {
    stateVersion = config.system.nixos.release; # Did you read the comment?
    copySystemConfiguration = false; # can't be used in a flake system
    };
}
