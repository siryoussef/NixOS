{ pkgs, pkgs-stable, settings, lib, ... }:

  let  OCIDirectory = "/Shared/@Containers/OCI/Root";
  in {
  imports = [
    ( import ./OCIstorageDriver.nix {storageDriver = "overlay"; inherit pkgs settings lib;} )
  ];
  users.users.${settings.user.username}.extraGroups = [ "docker" "podman" ];
  environment={
    systemPackages = with pkgs; [
  #     virtualbox
      distrobox
      boxbuddy
      virt-viewer
      spice spice-gtk
      spice-protocol
      win-virtio
      win-spice
      #virt-manager-qt (causes an error)
      virter
      lxqt.qtermwidget

      pods
      podman-tui
      podman-desktop
      podman-compose
      dive
      ]
      ++
      (with pkgs-stable;[
      quickemu
      quickgui
      ]);
    persistence.${settings.system.persistentStorage}= let storage = import settings.storagePath{inherit settings;}; in storage.persistent.libvirt.system;
  };
  programs.virt-manager={ enable = true; package= pkgs.virt-manager;};

  fileSystems={
    RootlessOCIConfig = {mountPoint = "/home/"+settings.user.username+"/.config/containers"; device = "/etc/nixos/user/containersConf"; options = ["bind" "rw" "user" "exec"]; fsType="auto";};

#     libvirt= {mountPoint ="/var/lib/libvirt"; device = "/Shared/libvirt/var/lib/libvirt"; options=["bind"]; fsType="auto";};
#     libvirtCache= {mountPoint ="/var/cache/libvirt"; device = "/Shared/libvirt/var/cache/libvirt"; options=["bind"]; fsType="auto";};
#     libvirtLogs= {mountPoint ="/var/log/libvirt"; device = "/Shared/libvirt/var/log/libvirt"; options=["bind"]; fsType="auto";};
    };
#   systemd = {
#     services.OCIperm = {
#       script = "chown -R "+settings.user.username+":users /Shared/@Containers/OCI";
#       wantedBy = [ "multi-user.target" ]; # starts after login
#       after = [/*"podman.service" "containerd.service" "Shared-\x40Containers-OCI-Storage-overlay.mount" "local-fs.target" "multi-user.target" "graphical.target"*/];
#     #     description = "...";
#     };
#     timers.OCIperm = {
#             wantedBy = ["timers.target"];
#             timerConfig = {
# #             OnCalendar = "daily";
#             OnBootSec = "1m";
#             Unit = "OCIperm.service";
#             };
#     };
#   };

  virtualisation = {
    containers = {
      enable = true;
      ociSeccompBpfHook.enable = true;
      storage.settings = {
        storage = {
          driver = "overlay";
          graphroot = OCIDirectory + "/Storage"; #"/var/lib/containers/storage";
          runroot = OCIDirectory + "/Runtime";   #"/run/containers/storage";
        };
      };
      registries = {
        block = [];
        insecure = [];
        search = ["docker.io" "quay.io" "ghcr.io" "public.ecr.aws"];
      };
      containersConf = {
        cniPlugins = [pkgs.cni-plugins];
        settings = {
#           "network_backend" = "netavark";
        };
      };
    };
    cri-o = {
      enable=true;
      };
    oci-containers = {
      backend = "podman";
      containers = {
        "genpod"={
          image="docker.io/gentoo/stage3:latest";
#           imageFile=""; workdir = "";
          user=settings.user.username+":users";
          hostname=settings.system.hostname;
          volumes=["Volume:/Volume"];
#           login={
#             username = settings.user.username;
#             registry = "";
#             password-file ="";
#             };
          };
        };
      };
    containerd = {enable =true; };

    podman = {enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
      autoPrune.enable = true;
      };
    docker = {enable = false;
      enableOnBoot = true;
      autoPrune.enable = true;
      };

    # LXD is a daemon that uses LXC (however uses only it's container creation but manages containers differently)
    lxc = { enable = true; lxcfs.enable = true;};
    lxd = { enable = true; # conflicts with distrobox as it disables cgroubsv2
      agent.enable = true;
      ui.enable = true;
      recommendedSysctlSettings = true;
      zfsSupport = true;
      };

    hypervGuest.enable = false;

    spiceUSBRedirection.enable = true;

    waydroid.enable = true;
    anbox = {enable = false; image = pkgs.anbox.image;};



    vmware.host = { enable = false; package = pkgs.vmware-workstation; };
    xen = {
      enable = false;
      package = pkgs.xen;
      qemu.package = pkgs.xen; #package-qemu = pkgs.xen;
      dom0Resources.memory = 512; #domain0MemorySize = 0;
      };
    virtualbox = {
      host = {
        enable = false;
        enableKvm = false;
        enableExtensionPack = true; #unfree
        addNetworkInterface = false;
        enableWebService = true;
        enableHardening = false;
        };
  #VirtualBox guest
      guest = { enable = false; seamless = true; dragAndDrop = true; clipboard = true ; };
    };
    kvmgt.enable = true;

    libvirtd = {
      enable = true;
      allowedBridges = [ "virbr0" "nm-bridge" ];
      onBoot = "start";
      parallelShutdown = 3;
      onShutdown = "suspend";
      qemu = {
        runAsRoot = false;
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
        };
        };
    libvirt ={ # from NixVirt flake
      enable=true;
      verbose=true;
      swtpm.enable=true;
      connections={
        "qemu:///system"={
          domains = [
            {definition=../virtualisation/libvirt/domains/win11.xml; active=true;}
          ];
          networks=[
            {definition=../virtualisation/libvirt/networks/default.xml;active=true;}
          ];
          pools=[
            {definition=../virtualisation/libvirt/storage/default.xml; active=true;}
            {definition=../virtualisation/libvirt/storage/DiscImgs.xml; active=true;
#               volumes=[
#                 {name="";
#                   present=true;
#                   definition="";
#                 }
#               ];
              }
          ];
        };
      };

    };

    multipass.enable = false;
    appvm = { enable = false; user = settings.user.username;};
    vswitch.enable = false;

/*
  fileSystems = {
    "/" = {
    device = "/dev/disk/by-label/Volume";
    fsType = mkForce."btrfs";
    options = [ "rw,subvol=ArchRoot" ];
    };
  };
*/

 /*

  #learn how to make overrides
  #self: super: {lxd = super.lxd.override = { systemd.enableUnifiedCgroupHierarchy = true } };

*/
  };
#   boot.extraModulePackages = with config.boot.kernelPackages; [  virtualbox  ]; # virtuabox not building error
}

