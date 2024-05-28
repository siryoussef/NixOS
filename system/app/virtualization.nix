{ config, pkgs, ... }:

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

  virtualisation = {
    waydroid.enable = true;
    lxd.enable = true;
    podman.enable = true;
    oci-containers.backend = "podman";
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
        enable = true;
        enableKvm = true;
        enableExtensionPack = true; #unfree
        addNetworkInterface = false;
        enableWebService = true;
        enableHardening = false;
        };
  #VirtualBox guest
      guest = { enable = false; seamless = true; draganddrop = true; clipboard = true ; };
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
    oci-containers.backend = "podman";
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

    podman.enable = true;
    podman.dockerCompat = true;

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
