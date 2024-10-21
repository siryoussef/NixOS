# This file is for centrally managing storage attachment by one of 3 methods (fstab mounts, Impermenance module (using bind mounts or symlinks), home-manager mkOutOfStoreSymlink method)
{  settings, config, ... }:
rec{
                  ## Home Source Path String ##
HSPS={
  plasma=((toString settings.paths.dotfiles)+"/plasma");#plasma user dotfiles path string
  waydroid="/Shared/@Home/waydroid/Data";
};
## Common symlinks set to be used in 1 of the 3 storage attachment methods ##

links={
  user.${settings.user.persistentStorage}= {
      directories = (map(x: ".local/share/"+x)[
        "onlyoffice"
        "kdevelop"
        "KotatogramDesktop"
        "kate"
#         "fish"
        "whatsapp-for-linux"
        ])++(map(x: ".config/"+x)[
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
      ];
      allowOther=true;
    };
  waydroid=rec{
      system."/Shared/@Home/waydroid"={directories=["/var/lib/waydroid"]; users.${settings.user.username}={directories=user.${HSPS.waydroid}.directories;};};
      user.${HSPS.waydroid}={directories=[".local/share/waydroid"]; files=[];};
  };
  libvirt={
      system.${settings.system.persistentStorage}={directories = ["/var/lib/libvirt" "/var/cache/libvirt" "/var/log/libvirt"];};
      user.${settings.user.persistentStorage}= {directories=[".config/libvirt"]; files=[];};
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
#       Home={mountPoint= "/home/" + settings.user.username; device = "none"; fsType = "tmpfs"; options = [/*"rw" "user" */ "uid=${settings.user.username}" "gid=users" "mode=777"]; depends = ["/"]; };# In-RAM-Home

    "/Volume" = { device = "/dev/disk/by-label/Volume"; fsType = "auto"; };
    "/Shared" = { device = "/dev/disk/by-label/Shared"; fsType = "auto"; neededForBoot=true; };
    "/boot/efi" = { device = "/dev/disk/by-label/BEFI"; fsType = "vfat"; };
     }
     //(builtins.mapAttrs(x: y: y // {device = "none"; fsType = "tmpfs"; options = [/*"rw" "user" */ "uid=${settings.user.username}" "gid=users" "mode=777"]; depends = ["/"];})rec{
     Home={mountPoint= "/home/" + settings.user.username;};
     local={mountPoint=Home.mountPoint+"/.local";};
     local-share={mountPoint=local.mountPoint+"/share";};
     cache={mountPoint=Home.mountPoint+"/.cache";};
     config={mountPoint=Home.mountPoint+"/.config";};

     })
     ;
BindMounts =(builtins.mapAttrs(x: y: y // {fsType = "none"; options=["bind" "mode=777"];}) rec{
  "/etc/nixos" = { device = "/Shared/@Repo/NixOS";};
  "/etc/nixos/secrets" = { device = "/Shared/@Repo/NixOS-private";};
  Downloads = { mountPoint = "/home/"+settings.user.username+"/Downloads"; device = "/Volume/@Storage/Downloads"; depends = [ "/" "/home" "/Volume"]; };
  vscode= {mountPoint = "/home/"+settings.user.username+"/.vscode"; device = "/Shared/@Home/.vscode";};
  fish={mountPoint = "/home/"+settings.user.username+"/.local/share/fish"; device = "/Shared/@Home/fish";};
#   kate={mountPoint = "/home/"+settings.user.username+"/.local/share/kate"; device = "/Shared/@Home/kate";};
#   kdevelop={mountPoint = "/home/"+settings.user.username+"/.local/share/kdevelop"; device = "/Shared/@Home/kdevelop";};
#   onlyoffice={mountPoint = "/home/"+settings.user.username+"/.local/share/onlyoffice"; device = "/Shared/@Home/onlyoffice";};
#   whatsapp-for-linux={ mountPoint = "/home/"+settings.user.username+"/.local/share/whatsapp-for-linux"; device = "/Shared/@Home/whatsapp-for-linux";};
#   KotatogramDesktop={mountPoint = "/home/"+settings.user.username+"/.local/share/KotatogramDesktop"; device = "/Shared/@Home/KotatogramDesktop";};
#   Github={mountPoint = "/home/"+settings.user.username+"/.config/GitHub Desktop"; device = "/Shared/@Home/.config/GitHub Desktop";};
  GitRepos= {mountPoint = "/home/"+settings.user.username+"/Documents/GitHub"; device = "/Shared/@Repo";};
  logseq= {mountPoint = "/home/"+settings.user.username+"/.logseq"; device = "/Shared/@Repo/Note/.logseq";};
  Note= {mountPoint = "/home/"+settings.user.username+"/Note"; device = "/Shared/@Repo/Note";};

   ## Flatpak bind mounts
  "/var/lib/flatpak" ={device = "/Shared/flatpak/system";};
  User-flatpaks ={mountPoint="/home/"+settings.user.username+"/.local/share/flatpak";device = "/Shared/flatpak/user";};
  FlatpakAppData ={mountPoint="/home/"+settings.user.username+"/.var/app";device = "/Shared/flatpak/appdata";};

  ## WebBrowsers
  floorp= { mountPoint = "/home/"+settings.user.username+"/.floorp"; device = "/Shared/@Home/.floorp";  };
  firedragonFlatpakProfiles={mountPoint= FlatpakAppData.mountPoint+"/org.garudalinux.firedragon/.firedragon"; device = floorp.device;};
  firedragonProfiles={mountPoint= "/home/"+settings.user.username+"/.firedragon"; device = floorp.device;};
  thunderbird= { mountPoint = "/home/"+settings.user.username+"/.thunderbird"; device = "/Shared/@Home/.thunderbird";  };

   ## Waydroid
  waydroidData={ mountPoint = "/home/"+settings.user.username+"/.local/share/waydroid"; device = HSPS.waydroid+"/.local/share/waydroid";};
  waydroidSystem={ mountPoint = "/var/lib/waydroid"; device = "/Shared/@Home/waydroid/System"; };
  waydroidDownloadsShareMain= { mountPoint = "/home/"+settings.user.username+"/.local/share/waydroid/data/media/0/Download"; device = "/home/"+settings.user.username+"/Downloads"; depends = [ "/" "/home" "/Volume" ] ++ (map(x: "${x.mountPoint}")[Downloads waydroidData]); }; #could be simpler without the map function if one variable & may work perfectly without the depends option at all ! ,  but this is for educatory purposes to help in future modifications

   ## Plasma config files!!
#    kateConfig={ mountPoint = "/home/"+settings.user.username+"/kate"; device = "/Shared/@Home/.config/kate";  };
  });
## Overlayfs

fileSystems = DiscMounts//BindMounts;

                  ##    2nd: Impermenance module  ##
persistent={
	system.${settings.system.persistentStorage}={
		directories= [
# 		"/var/log"
# 		"/var/lib/bluetooth"
# 		"/var/lib/nixos"
# 		"/var/lib/systemd/coredump"
		"/etc/NetworkManager/system-connections"
		{ directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
		];
		files = [
		"/etc/machine-id"
		{ file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
		];
    };
    user=links.user;

    libvirt=links.libvirt;
    plasma=links.plasma;
    waydroid=links.waydroid;

  };

                  ##    3rd: home.file+mkOutOfStoreSymlink  ##
homeLinks={
  user=
    builtins.listToAttrs (map (y:{name=y; value={source=(config.lib.file.mkOutOfStoreSymlink(/. + (settings.user.persistentStorage+"/${y}")));};})(with links.user.${settings.user.persistentStorage};(files++directories)));
  plasma=
    builtins.listToAttrs (map (y:{name=y; value={source=(config.lib.file.mkOutOfStoreSymlink(/. + (HSPS.plasma+"/${y}")));};})(with links.plasma.user.${HSPS.plasma};(files++directories)));
  waydroid=
    builtins.listToAttrs (map (y:{name=y; value={source=(config.lib.file.mkOutOfStoreSymlink(/. + (HSPS.waydroid+"/${y}")));};})(with links.waydroid.user.${HSPS.waydroid};(files++directories)));
  libvirt=
    builtins.listToAttrs (map (y:{name=y; value={source=(config.lib.file.mkOutOfStoreSymlink(/. + (settings.user.persistentStorage+"/${y}")));};})(with links.libvirt.user.${settings.user.persistentStorage};(files++directories)));

#   waydroid= builtins.listToAttrs(map(x:{name=x; value=let config=config; in {source=config.lib.file.mkOutOfStoreSymlink (settings.paths.dotfiles)/plasma/${x};};}) (with links.waydroid.user.${plasmaUser};(files++directories)));
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
none     /home/${settings.user.username}          tmpfs    defaults,noatime,uid=${settings.user.username},gid=users,mode=777 0 2
none     /home/${settings.user.username}/.local          tmpfs    defaults,noatime,uid=${settings.user.username},gid=users,mode=777 0 2
none     /home/${settings.user.username}/.local/share          tmpfs    defaults,noatime,uid=${settings.user.username},gid=users,mode=777 0 2
none     /home/${settings.user.username}/.config          tmpfs    defaults,noatime,uid=${settings.user.username},gid=users,mode=777 0 2
none     /home/${settings.user.username}/.cache         tmpfs    defaults,noatime,uid=${settings.user.username},gid=users,mode=777 0 2
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

/Shared/@Home/.vscode   /home/${settings.user.username}/.vscode   auto   bind,defaults 0 2
/Shared/@Home/.thunderbird   /home/${settings.user.username}/.thunderbird   auto   bind,defaults 0 2
/Shared/@Home/.floorp   /home/${settings.user.username}/.floorp   auto   bind,defaults 0 2
/Shared/@Home/.floorp /home/${settings.user.username}/.var/app/org.garudalinux.firedragon/.firedragon none bind 0 0
/Shared/@Home/.floorp /home/${settings.user.username}/.firedragon none bind 0 0
/Shared/@Home/fish      /home/${settings.user.username}/.local/share/fish   auto   bind,defaults 0 2
/Volume/@Storage/Downloads     /home/${settings.user.username}/Downloads   auto   bind,defaults 0 2

/Shared/@Home/.config/GitHub\ Desktop  /home/${settings.user.username}/.config/GitHub\ Desktop  auto bind,defaults 0 2
/Shared/@Repo           /home/${settings.user.username}/Documents/GitHub  auto  bind,defaults 0 2
#/dev/disk/by-uuid/3448b71e-714f-42c2-b642-1f025112d4ea /mnt/3448b71e-714f-42c2-b642-1f025112d4ea btrfs nosuid,nodev,nofail,x-gvfs-show,ro,rescue=all 0 0
#/dev/disk/by-label/Volume /Volume auto nosuid,nodev,nofail,x-gvfs-show 0 0

/Shared/flatpak/system /var/lib/flatpak none bind 0 0
/Shared/flatpak/user /home/${settings.user.username}/.local/share/flatpak none bind 0 0
/Shared/flatpak/appdata /home/${settings.user.username}/.var/app none bind 0 0

'';
}
# persistent=persistent;
# }
#   merged = (lib.recursiveUpdate DiscMounts BindMounts);

