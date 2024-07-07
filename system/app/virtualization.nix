{ pkgs, userSettings, ... }:
  let
  OCIDirectory = "/Shared/@Containers/OCI";
  in {
  environment.systemPackages = with pkgs; [
#     virtualbox
    distrobox
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
    ];

  programs.virt-manager={ enable = true; package= pkgs.virt-manager;};




  fileSystems."RootlessOCIConfig" = {mountPoint = "/home/"+userSettings.username+"/.config/containers/storage.conf"; device = "/etc/containers/storage.conf"; options = ["bind" "rw" "user" "exec"]; fsType="auto";};
  systemd = {
    services.OCIperm = {
      script = "chown -R "+userSettings.username+":users /Shared/@Containers/OCI";
      wantedBy = [ "multi-user.target" ]; # starts after login
      after = [/*"podman.service" "containerd.service" "Shared-\x40Containers-OCI-Storage-overlay.mount" "local-fs.target" "multi-user.target" "graphical.target"*/];
    #     description = "...";
    };
    timers.OCIperm = {
            wantedBy = ["timers.target"];
            timerConfig = {
#             OnCalendar = "daily";
            OnBootSec = "1m";
            Unit = "OCIperm.service";
            };
    };
  };

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
      storageDriver = "overlay";

      };
    oci-containers = {
      backend = "podman";
      containers = {};
      };
    containerd = {enable =true; };

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

    podman = {enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
      };

    vmware.host = { enable = false; package = pkgs.vmware-workstation; };
    xen = {
      enable = false;
      package = pkgs.xen;
      package-qemu = pkgs.xen;
      domain0MemorySize = 0;
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

    multipass.enable = false;
    appvm = { enable = false; user = userSettings.username;};
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
