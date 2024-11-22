# This file is for centrally managing storage attachment by one of 3 methods (fstab mounts, Impermenance module (using bind mounts or symlinks), home-manager mkOutOfStoreSymlink method)
{  settings, config, ... }:
rec{
                ## Abbreviations ##
userdir = settings.paths.persistentHome;
username = settings.user.username;
persistentSystemDir = settings.paths.persistentSystem;
                ## Home Source Path String ##
HSPS={
  plasma=((toString settings.paths.dotfiles)+"/plasma");#plasma user dotfiles path string
  waydroid=userdir+"/waydroid/Data";
  junest=userdir+"/.junest";
};
## Common symlinks set to be used in 1 of the 3 storage attachment methods ##

links={
  user.${userdir}= {
      directories = (map(x: ".local/share/"+x)[
        "onlyoffice"
        "kdevelop"
        "KotatogramDesktop"
        "KDE/neochat"
        "kate"
#         "fish"
        "whatsapp-for-linux"
        ])++(map(x: ".config/"+x)[
        "guix"
        "thorium"
        "session"
        "obsidian"
        "GitHub Desktop"
        ])++[
#         "Downloads"
        "Music"
        "Pictures"
#        "Documents"
        "Videos"
        "VirtualBox VMs"
        "Desktop"
        ".gnupg"
        ".ssh"
        ".nixops"
        ".jupyter"
#         ".mysql"
        ".android"
        "kdeconnect"
        ".cache/zen"
        ".zen"
        ".cache/KDE/neochat"
#         ".floorp"
#         { directory = ".gnupg"; mode = "0700"; }
#         { directory = ".ssh"; mode = "0700"; }
#         { directory = ".nixops"; mode = "0700"; }
#         { directory = ".local/share/keyrings"; mode = "0700"; }
#         ".local/share/direnv"
#       ".local/share/keyrings"

#         ".thunderbird" # errors with mkOutOfStoreSymlink ! FIXME
      ]
#       ++(map(dir:{directory=dir; method="symlink";}) ["Music"])
      ;
      files = [
        ".screenrc"
        ".gtkrc-2.0"
        ".bash_history"
        ".gitconfig"
        ".config/neochatrc"
        ".config/KDE/neochat.conf"
      ];
      allowOther=true;
    };
  libvirt={
      system.${persistentSystemDir}={directories = ["/var/lib/libvirt" "/var/cache/libvirt" "/var/log/libvirt"];};
      user.${userdir}= {directories=[".config/libvirt"]; files=[];};
  };
  vscode.user.${userdir} ={ directories =[ ".config/Code" ".vscode" ]; files=[]; };

  waydroid=rec{
      system."${userdir}/waydroid"={directories=["/var/lib/waydroid"]; users.${username}={directories=user.${HSPS.waydroid}.directories;};};
      user.${HSPS.waydroid}={directories=[".local/share/waydroid"]; files=[];};
  };


  plasma={
      system={
        directories=[];
        files=[];
        };
      user.${HSPS.plasma} = {
        allowOther=true;
        directories=
        (map(x: ".local/share/"+x)[
          "kwalletd"
          "dolphin"
          "baloo"
          "klipper"
          "konsole"
        ])++(map(x: ".config/"+x)[
          "kde.org"
          "gtk-3.0"
          "gtk-4.0"
          "xsettingsd"
        ]);
        files=(map(x: ".config/"+x)[
          "katerc"
          "konsolerc"
          "dolphinrc"
          "kwinrc"
          "kdeglobals"
          "kwinrulesrc"
          "kxkbrc"
          "kdedefaults/kscreenlockerrc"
          "plasmashellrc"
          "plasma-org.kde.plasma.desktop-appletsrc"
          "kglobalshortcutsrc"
          "kwinoutputconfig.json"
          "kwalletrc"

          "kactivitymanagerdrc"
          "kded5rc"
          "kconf_updaterc"
          "plasma-localerc"
          "ktimezonedrc"
          "PlasmaDiscoverUpdates"
          "gtkrc-2.0"
          "gtkrc"
          "Trolltech.conf"
          "baloofileinformationrc"
          "baloofilerc"
          "bluedevilglobalrc"
        ]);
      };
  };

};

                  ##    1st: fstab mounts  ##
DiscMounts = rec{
    "/" = { device = "none"; fsType = "tmpfs"; /*options=["mode=777"];*/}; # In-RAM-Root
#     "/" = { device = "/dev/disk/by-label/NRoot"; fsType = "btrfs"; };
    "/nix" = { device = "/dev/disk/by-label/Nix"; fsType = "ext4"; depends = ["/" "/home"];};
    "/boot" = { device = "/dev/disk/by-label/Boot"; fsType = "btrfs"; options = [ "subvol=@Nix" ]; };
#     "/home" = { device = "/dev/disk/by-label/Home"; fsType = "btrfs"; options =["subvol=@NHome"];};
#       Home={mountPoint= "/home/" + username; device = "none"; fsType = "tmpfs"; options = [/*"rw" "user" */ "uid=${username}" "gid=users" "mode=777"]; depends = ["/"]; };# In-RAM-Home

    "/Volume" = { device = "/dev/disk/by-label/Volume"; fsType = "auto"; };
    "/Shared" = { device = "/dev/disk/by-label/Shared"; fsType = "auto"; neededForBoot=true; };
    "/boot/efi" = { device = "/dev/disk/by-label/BEFI"; fsType = "vfat"; };
     }
     //(builtins.mapAttrs(x: y: y // {device = "none"; fsType = "tmpfs"; options = [/*"rw" "user" */ "uid=${username}" "gid=users" "mode=777"]; depends = ["/"];})rec{
     Home={mountPoint= "/home/" + username;};
     local={mountPoint=Home.mountPoint+"/.local";};
     local-share={mountPoint=local.mountPoint+"/share";};
     cache={mountPoint=Home.mountPoint+"/.cache";};
     config={mountPoint=Home.mountPoint+"/.config";};

     })
     ;
BindMounts =(builtins.mapAttrs(x: y: y // {fsType = "none"; options=["bind" "mode=777" ];}) rec{
  "/etc/nixos" = { device = "/Shared/@Repo/NixOS";};
  "/etc/nixos/secrets" = { device = "/Shared/@Repo/NixOS-private";};
  Downloads = { mountPoint = "/home/"+username+"/Downloads"; device = "/Volume/@Storage/Downloads"; depends = [ "/" "/home" "/Volume"]; };
#   vscode= {mountPoint = "/home/"+username+"/.vscode"; device = userdir+"/.vscode";};
  fish={mountPoint = "/home/"+username+"/.local/share/fish"; device = userdir+"/fish";};
#   kate={mountPoint = "/home/"+username+"/.local/share/kate"; device = userdir+"/kate";};
#   kdevelop={mountPoint = "/home/"+username+"/.local/share/kdevelop"; device = userdir+"/kdevelop";};
#   onlyoffice={mountPoint = "/home/"+username+"/.local/share/onlyoffice"; device = userdir+"/onlyoffice";};
#   whatsapp-for-linux={ mountPoint = "/home/"+username+"/.local/share/whatsapp-for-linux"; device = userdir+"/whatsapp-for-linux";};
#   KotatogramDesktop={mountPoint = "/home/"+username+"/.local/share/KotatogramDesktop"; device = userdir+"/KotatogramDesktop";};
#   Github={mountPoint = "/home/"+username+"/.config/GitHub Desktop"; device = userdir+"/.config/GitHub Desktop";};
  GitRepos= {mountPoint = "/home/"+username+"/Documents/GitHub"; device = "/Shared/@Repo";};
  logseq= {mountPoint = "/home/"+username+"/.logseq"; device = "/Shared/@Repo/Note/.logseq";};
  Note= {mountPoint = "/home/"+username+"/Note"; device = "/Shared/@Repo/Note";};

   ## Flatpak bind mounts
  "/var/lib/flatpak" ={device = "/Shared/flatpak/system";};
  User-flatpaks ={mountPoint="/home/"+username+"/.local/share/flatpak";device = "/Shared/flatpak/user";};
  FlatpakAppData ={mountPoint="/home/"+username+"/.var/app";device = "/Shared/flatpak/appdata";};

  ## WebBrowsers
  floorp= { mountPoint = "/home/"+username+"/.floorp"; device = userdir+"/.floorp";  };
  firedragonFlatpakProfiles={mountPoint= FlatpakAppData.mountPoint+"/org.garudalinux.firedragon/.firedragon"; device = floorp.device;};
  firedragonProfiles={mountPoint= "/home/"+username+"/.firedragon"; device = floorp.device;};
  thunderbird= { mountPoint = "/home/"+username+"/.thunderbird"; device = userdir+"/.thunderbird";  };

   ## Waydroid
  waydroidData={ mountPoint = "/home/"+username+"/.local/share/waydroid"; device = HSPS.waydroid;};
  waydroidSystem={ mountPoint = "/var/lib/waydroid"; device = userdir+"/waydroid/System"; };
  waydroidDownloadsShareMain= { mountPoint = "/home/"+username+"/.local/share/waydroid/data/media/0/Download"; device = Downloads.device; depends = [ "/" "/home" "/Volume" ] ++ (map(x: "${x.mountPoint}")[Downloads waydroidData]); }; #could be simpler without the map function if one variable & may work perfectly without the depends option at all ! ,  but this is for educatory purposes to help in future modifications

   ## Plasma config files!!
#    kateConfig={ mountPoint = "/home/"+username+"/kate"; device = userdir+"/.config/kate";  };
  });
## Overlayfs

fileSystems = DiscMounts//BindMounts;

                  ##    2nd: Impermenance module  ##
persistent={
	system.${persistentSystemDir}={
		directories= [
# 		"/var/log"
# 		"/var/lib/bluetooth"
# 		"/var/lib/nixos"
# 		"/var/lib/systemd/coredump"
		"/etc/NetworkManager/system-connections"
		{ directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
		];
		files = [
# 		"/etc/machine-id" # causes an error in the switch mechanism
		{ file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
		];
    };
    opensearch.system.${persistentSystemDir}.directories=["/var/lib/opensearch"];
    user=links.user;

    libvirt=links.libvirt;
    plasma=links.plasma;
    waydroid=links.waydroid;
#   guix={
#     ${settings.paths.guixConf}={
#       users.${settings.user.username}={
#         directories=[
#         ".config/guix"
#         ];
#         files=[
#
#         ];
#       };
#     };
#   };
  };

                  ##    3rd: home.file+mkOutOfStoreSymlink  ##
# symlink = mylink: mytarget: settings.inputs.symlink.symlink {
#       system = settings.system.arch;
#       utils = settings.pkgs.coreutils;
#       # ↑ This is optional if in impure mode. It is replaced with busybox from nixpkgs.
#       shell = "${settings.pkgs.bash}/bin/sh";
#       # ↑ This is optional if utils provides …/bin/sh, like if using busybox.
#       link = mylink;
#       target = mytarget;
#       link-label = "link-label";
      # ↑ This is optional if link doesn't depend on a derivation.
#       target-label = "target-label";
      # ↑ This is optional if target doesn't depend on a derivation.
#     };
mkOOSLinkSet2 = { prefix, linkSet }:
    builtins.listToAttrs (map (y: { name = y; value ={ source = let
      symlink = settings.inputs.symlink.symlink {
      system = settings.system.arch;
      utils = settings.pkgs.coreutils;
      # ↑ This is optional if in impure mode. It is replaced with busybox from nixpkgs.
      shell = "${settings.pkgs.bash}/bin/sh";
      # ↑ This is optional if utils provides …/bin/sh, like if using busybox.
      link = y;
      target = (/. + (prefix + "/${y}"));};
      in "${symlink}";  }; }) (with linkSet; (files++directories)));
        # Abstract function to generate symlinked home links (make out of store link set)
mkOOSLinkSet = { prefix, linkSet }:
    builtins.listToAttrs (map (y: { name = y; value ={ source =  config.lib.file.mkOutOfStoreSymlink(/. + (prefix + "/${y}"));};}) (with linkSet; (files++directories)));

homeLinks= {
  user= mkOOSLinkSet {prefix=userdir; linkSet = (links.user.${userdir}); };
  libvirt=mkOOSLinkSet {prefix=(userdir); linkSet=(links.libvirt.user.${userdir}); };
  vscode=mkOOSLinkSet {prefix=(userdir); linkSet=(links.vscode.user.${userdir}); };

  plasma=mkOOSLinkSet {prefix=(HSPS.plasma); linkSet=(links.plasma.user.${HSPS.plasma}); };
  waydroid=mkOOSLinkSet {prefix=(HSPS.waydroid); linkSet=(links.waydroid.user.${HSPS.waydroid}); };
  };# A set to implement symlinking in home-manager in different manner than persistence module (to be further compared with persistence!)

fstab= ''
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a device; this may
# be used with UUID= as a more robust way to name devices that works even if
# disks are added and removed. See fstab(5).
#
# <file system>             <mount point>  <type>  <options>  <dump>  <pass>
LABEL=Boot /boot          btrfs    subvol=@Arch,defaults,noatime 0 2
LABEL=BEFI  /boot/efi      vfat    defaults,noatime 0 2
# LABEL=Home /home          auto    subvol=@AHome,defaults,noatime 0 2
none     /home/${username}          tmpfs    defaults,noatime,uid=${username},gid=users,mode=777 0 2
none     /home/${username}/.local          tmpfs    defaults,noatime,uid=${username},gid=users,mode=777 0 2
none     /home/${username}/.local/share          tmpfs    defaults,noatime,uid=${username},gid=users,mode=777 0 2
none     /home/${username}/.config          tmpfs    defaults,noatime,uid=${username},gid=users,mode=777 0 2
none     /home/${username}/.cache         tmpfs    defaults,noatime,uid=${username},gid=users,mode=777 0 2
LABEL=ARoot /              ext4    defaults,noatime 0 1
LABEL=Nix   /nix           ext4    defaults,noatime 0 2
LABEL=Volume  /Volume       auto   defaults,rw,noatime,x-gvfs-show 0 2
LABEL=Shared /Shared auto nosuid,nodev,nofail,rw,x-gvfs-show 0 2

LABEL=NRoot   /mnt/NixOS     btrfs    defaults,noatime 0 2
# none     /mnt/NixOS          tmpfs    defaults,noatime 0 2
LABEL=Nix   /mnt/NixOS/nix     ext4   defaults,noatime   0 2
# LABEL=NHome /mnt/NixOS/home   btrfs  defaults,noatime  0 2
none     /mnt/NixOS/home   tmpfs  defaults,noatime  0 2
LABEL=Boot  /mnt/NixOS/boot   btrfs   subvol=@Nix,defaults,noatime   0 2
LABEL=BEFI  /mnt/NixOS/boot/efi  vfat  defaults,noatime   0 2
#LABEL=Volume  /mnt/NixOS/Volume auto  defaults,noatime,x-gvfs-hide 0 2
LABEL=Shared /mnt/NixOS/Shared auto nosuid,nodev,nofail,rw,x-gvfs-show 0 2

/mnt/NixOS/Shared/@Repo/NixOS   /mnt/NixOS/etc/nixos    auto   bind,defaults,x-gvfs-hide  0 2

${userdir}/.vscode   /home/${username}/.vscode   auto   bind,defaults 0 2
${userdir}/.thunderbird   /home/${username}/.thunderbird   auto   bind,defaults 0 2
${userdir}/.floorp   /home/${username}/.floorp   auto   bind,defaults 0 2
${userdir}/.floorp /home/${username}/.var/app/org.garudalinux.firedragon/.firedragon none bind 0 0
${userdir}/.floorp /home/${username}/.firedragon none bind 0 0
${userdir}/fish      /home/${username}/.local/share/fish   auto   bind,defaults 0 2
/Volume/@Storage/Downloads     /home/${username}/Downloads   auto   bind,defaults 0 2

${userdir}/.config/GitHub\ Desktop  /home/${username}/.config/GitHub\ Desktop  auto bind,defaults 0 2
/Shared/@Repo           /home/${username}/Documents/GitHub  auto  bind,defaults 0 2
#/dev/disk/by-uuid/3448b71e-714f-42c2-b642-1f025112d4ea /mnt/3448b71e-714f-42c2-b642-1f025112d4ea btrfs nosuid,nodev,nofail,x-gvfs-show,ro,rescue=all 0 0
#/dev/disk/by-label/Volume /Volume auto nosuid,nodev,nofail,x-gvfs-show 0 0

/Shared/flatpak/system /var/lib/flatpak none bind 0 0
/Shared/flatpak/user /home/${username}/.local/share/flatpak none bind 0 0
/Shared/flatpak/appdata /home/${username}/.var/app none bind 0 0

'';
}
# persistent=persistent;
# }
#   merged = (lib.recursiveUpdate DiscMounts BindMounts);

