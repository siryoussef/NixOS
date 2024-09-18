{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.consoleLogLevel = 0;
  boot.extraModulePackages = with config.boot.kernelPackages; [
    zenpower
  ];
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
}
