# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-stable, lib, systemSettings, userSettings, ... }:
{
  imports =
    [ #../../configuration.nix
      ../../system/hardware-configuration.nix
      ../../system/hardware/systemd.nix # systemd config
      ../../system/hardware/kernel.nix # Kernel config
      ../../system/hardware/power.nix # Power management
      ../../system/hardware/time.nix # Network time sync
      ../../system/hardware/printing.nix
      ../../system/hardware/bluetooth.nix
      (./. + "../../../system/wm"+("/"+userSettings.wm)+".nix") # My window manager
      ../../system/app/appsupport.nix
      ../../system/app/distrobox.nix
      ../../system/app/virtualization.nix
      ( import ../../system/app/docker.nix {storageDriver = "btrfs"; inherit userSettings lib;} )
      ../../system/app/syncthing.nix
      ../../system/security/doas.nix
      ../../system/security/gpg.nix
      ../../system/security/blocklist.nix
      ../../system/security/firewall.nix
      ../../system/security/firejail.nix
      ../../system/security/openvpn.nix
      ../../system/security/automount.nix
      ../../system/style/stylix.nix
      ../../system/app/sh.nix
      ../../system/app/develop.nix
      ../../syspkgs.nix
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
      systemd-boot.enable = /*if (systemSettings.bootMode == "uefi") then true else*/ false;
  #efi.canTouchEfiVariables = if (systemSettings.bootMode == "uefi") then true else false;
   # Bootloader.
      generationsDir.copyKernels = true;
      timeout = 3;

      grub = {enable = /*if (systemSettings.bootMode == "uefi") then false else*/ true;
          device = systemSettings.grubDevice; # does nothing if running uefi rather than bios
          efiSupport = true;
          efiInstallAsRemovable = true;
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
  networking = { hostName = systemSettings.hostname; # Define your hostname.
  networkmanager.enable = true; # Use networkmanager
  enableIPv6 = true;
  useDHCP = false;
  wireless = {
    #enable = true;
    networks = { Fankoosh = {                   # SSID with no spaces or special characters
    psk = "Dodadoda11";           # (password will be written to /nix/store!)
  };
};
    fallbackToWPA2 = true;
    };
  useNetworkd = true;
  hostId = "94fde329";
  #wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # proxy.default = "http://user:password@proxy:port/";
  # proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  };

  # Timezone and locale
  time.timeZone = systemSettings.timezone; # time zone
  i18n.defaultLocale = systemSettings.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.locale;
    LC_IDENTIFICATION = systemSettings.locale;
    LC_MEASUREMENT = systemSettings.locale;
    LC_MONETARY = systemSettings.locale;
    LC_NAME = systemSettings.locale;
    LC_NUMERIC = systemSettings.locale;
    LC_PAPER = systemSettings.locale;
    LC_TELEPHONE = systemSettings.locale;
    LC_TIME = systemSettings.locale;
  };

  # User account
users = {
  defaultUserShell = pkgs.fish;
  users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "networkmanager" "wheel" "input" "dialout" "libvirtd" "vboxusers" "aria2" "syncthing"];
    packages = with pkgs; [];
    uid = 1000;
  };
  extraGroups.vboxusers.members = [ userSettings.username ];
};

environment = {
  shells = with pkgs; [ fish zsh bash ];
  sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  # List packages installed in system profile.
  #systemPackages = with pkgslists;(UnStable++Stable);
  };
  fonts.fontDir.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Install the zen kernel
#   boot.kernelPackages = pkgs.linuxPackages_zen;

  ## ZFS
/*
boot = {
  zfs = {
    enabled = lib.mkOverride 1000 true;
    removeLinuxDRM = true;
    forceImportRoot = false;
    forceImportAll = false;
    enableUnstable = true;
    allowHibernation = true;
    };
  };
*/

 # boot.kernelParams = [ "mem_sleep_default=deep" "zfs.zfs_arc_max=12884901888" "boot.shell_on_fail" /* "resume=/dev/disk/by-uuid/50ee6795-a53f-f245-a3d0-cfabbfb81097" "resume_offset=933263" */ ];
  /*
  boot.initrd.kernelModules = [
 "dm-cache-default" # when using volumes set up with lvmcache
];
  boot.initrd.services.lvm.enable = true;
  boot.initrd.enable = true;
  */
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
  libreddit.enable = true;
  onlyoffice.enable = false;
  logind.hibernateKey = "hibernate";
  autosuspend.settings = {
  enable = true;
  interval = 21;
  idle_time = 70;
};
  autosuspend.enable = true;
  blueman.enable = true;
  aria2 = { enable = true; settings.dir = "/Volume/@Storage/Downloads";
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
  displayManager.autoLogin = { enable = true; user = userSettings.username; };
  spice-vdagentd.enable = true ;
  pipewire = {
    enable = true;
    alsa = { enable = true; support32Bit = true; };
    pulse.enable = true;
  };
  samba-wsdd.enable = true;
  samba = {
    enable = true;
    enableNmbd = true;
    enableWinbindd = true;
    openFirewall= true;
    nsswins = true;
    shares =
    { Shared = { path = "/Shared"; "read only" = false; browseable = "yes"; "guest ok" = "yes"; comment = "Wanky shared volume"; };
      Labvol = { path = "/Volume"; "read only" = false; browseable = "yes"; "guest ok" = "yes"; comment = "Wanky Main Volume"; };
    };
  };

  logrotate.checkConfig = false;
  #logrotate is disabled due to an error during build
};
  console.useXkbConfig = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable sound with pipewire.
  sound.enable = true;
  hardware = {
    pulseaudio.enable = false;
    cpu = { intel = { updateMicrocode = true; sgx.provision.enable = true; };
            x86.msr.enable = true; };
    bluetooth = { enable = true; powerOnBoot = true; };
  };
security = {
  rtkit.enable = true;
  #ipa.chromiumSupport = true;
  #chromiumSuidSandbox.enable = true;
  tpm2.enable = false;
  apparmor.enable = false;
  allowSimultaneousMultithreading = true;
  polkit.enable = true;
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
  enableUnifiedCgroupHierarchy = pkgs.lib.mkForce  true;
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

 #Controversial
 # Allow unfree packages
  nixpkgs = { config = { allowUnfree = true; allowBroken = true; }; };

  nixpkgs.config.permittedInsecurePackages = [
#     "xen-4.15.1"
#     "openssl-1.1.1w"
#     "openssl-1.1.1u"
  ];

  # Enable flatpak support
  services.flatpak.enable = true;
  # firejail
nix = {
  # Fix nix path
  nixPath = [ "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
                  "nixos-config=$HOME/dotfiles/system/configuration.nix"
                  "/nix/var/nix/profiles/per-user/root/channels"
                ];
  package = pkgs.nixFlakes;
  extraOptions = ''
    experimental-features = nix-command flakes
  '';
  checkAllErrors = true;
  checkConfig = true;
  optimise = { automatic = true; dates = [ "weekly" ]; };
  gc = { automatic = true;  dates = "weekly"; };
  #extraOptions = '' experimental-features = nix-command flakes '';
  channel.enable = true;
  settings = { auto-optimise-store = true;
               experimental-features = ["nix-command " "flakes" /*"configurable-impure-env"*/ "auto-allocate-uids"] ; };
  #registry = { };
  #registry = { "flakes"=[]  "version" 2; };
};

programs = {
  firejail.enable = true;
  captive-browser.enable = false;
  partition-manager.enable = true;
  git.enable = true;
  appimage = { enable = true; binfmt = true;};
  #cfs-zen-tweaks.enable = true;
  dconf.enable = true;
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

  firefox = {
    enable = true;
    package = pkgs-stable.floorp;
    nativeMessagingHosts = {
    packages = with pkgs; [ uget-integrator browserpass];
  # uget-integrator = true;
  # browserpass = true; ##deprecated
    };
  };
  kdeconnect = { enable = true; /* package = pkgs.plasma5Packages.kdeconnect-kde; */ };
#   singularity = {enable=true; package=pkgs.apptainer; enableFakeroot=true; enableSuid=true; };
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
