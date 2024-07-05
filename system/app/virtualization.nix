{ config, pkgs, userSettings, ... }:

{
  environment.systemPackages = with pkgs; [
    virt-manager
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
    ];
  fileSystems."RootlessOCIConfig" = {mountPoint = "/home/"+userSettings.username+"/.config/containers/storage.conf"; device = "/etc/containers/storage.conf"; options = ["bind"]; fsType="auto";};
  virtualisation = {
    containers = {
      enable = true;
      ociSeccompBpfHook.enable = true;
      storage.settings = {
        storage = {
          driver = "overlay";
          graphroot = "/Volume/@Pot/Containers/OCI/Storage"; #"/var/lib/containers/storage";
          runroot = "/Volume/@tmp/Containers/OCI/Runtime";   #"/run/containers/storage";
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

    waydroid.enable = true;
    lxd.enable = true;
    podman = {enable = true; dockerCompat = true; dockerSocket.enable = true;};

    vmware.host = { enable = false; package = pkgs.vmware-workstation; };
    lxc.lxcfs.enable = true;
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
      qemu.runAsRoot = false;
    };
    multipass.enable = false;
    appvm.enable = false;
    appvm.user = "youssef";
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
 #  hypervGuest.enable = true;
    oci-containers.containers = { };
    containerd.enable = true;
    kvmgt.enable = false;
  # LXD is a daemon that uses LXC (however uses only it's container creation but manages containers differently)
    lxc.enable = true;
    lxc.lxcfs.enable = true;
    lxd.enable = false; # conflicts with distrobox as it disables cgroubsv2
    lxd.agent.enable = true;
    lxd.ui.enable = true;
    lxd.recommendedSysctlSettings = true;
    lxd.zfsSupport = true;
  #learn how to make overrides
  #self: super: {lxd = super.lxd.override = { systemd.enableUnifiedCgroupHierarchy = true } };

    containers.enable = true;
    spiceUSBRedirection.enable = true;


  #Anbox
    anbox.enable = false;
    anbox.image = pkgs.anbox.image;

  # waydroid.image = "https://waydroid.dev/images/android-12-arm64.img.xz";

    xen.enable = false;

    programs.virt-manager.enable = true;
    libvirtd.enable = true;

    libvirtd.qemu = {
    swtpm.enable = true;
    ovmf.enable = true;
    ovmf.packages = [ pkgs.OVMFFull.fd ];
    };


    libvirtd.onShutdown = "suspend";
    libvirtd.parallelShutdown = 3;
    libvirtd.allowedBridges = [
    "virbr0"
    ];
    libvirtd.onBoot = "start";
*/
  };
  boot.extraModulePackages = with config.boot.kernelPackages; [ /* virtualbox */ ]; # virtuabox not building error
}
