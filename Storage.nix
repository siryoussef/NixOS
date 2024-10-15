# This file is for centrally managing storage attachment by one of 3 methods (fstab mounts, Impermenance module (using bind mounts or symlinks), home-manager mkOutOfStoreSymlink method)
{  settings, ... }:
rec{
## Common symlinks set to be used in 1 of the 3 storage attachment methods ##
plasmaUser=((toString settings.paths.dotfiles)+"/plasma");#plasma user dotfiles path string
links={
  waydroid={

      system."/Shared/@Home/waydroid/System"={directories=["/var/lib/waydroid"];};
      user."/Shared/@Home/waydroid/Data"={directories=[".local/share/waydroid"];};
  };
  libvirt={
      system.${settings.system.persistentStorage}={directories = ["/var/lib/libvirt" "/var/cache/libvirt" "/var/log/libvirt"];};
      user.${settings.user.persistentStorage}= {directories=["/.config/libvirt"];};
  };
  plasma={
      system={
        directories=[];
        files=[];
        };
      user.${plasmaUser} = {
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
  kate={mountPoint = "/home/"+settings.user.username+"/.local/share/kate"; device = "/Shared/@Home/kate";};
#   kdevelop={mountPoint = "/home/"+settings.user.username+"/.local/share/kdevelop"; device = "/Shared/@Home/kdevelop";};
#   onlyoffice={mountPoint = "/home/"+settings.user.username+"/.local/share/onlyoffice"; device = "/Shared/@Home/onlyoffice";};
  whatsapp-for-linux={ mountPoint = "/home/"+settings.user.username+"/.local/share/whatsapp-for-linux"; device = "/Shared/@Home/whatsapp-for-linux";};
  KotatogramDesktop={mountPoint = "/home/"+settings.user.username+"/.local/share/KotatogramDesktop"; device = "/Shared/@Home/KotatogramDesktop";};
  Github={mountPoint = "/home/"+settings.user.username+"/.config/GitHub Desktop"; device = "/Shared/@Home/.config/GitHub Desktop";};
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

   ## Waydroid
  waydroidData={ mountPoint = "/home/"+settings.user.username+"/.local/share/waydroid"; device = "/Shared/@Home/waydroid/waydroidData";};
  waydroidSystem={ mountPoint = "/var/lib/waydroid"; device = "/Shared/@Home/waydroid/waydroidSystem"; };
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
    user.${settings.user.persistentStorage}= {
      directories = [
#         "Downloads"
#         "Music"
        "Pictures"
        "Documents"
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
        ".config/thorium"
        ".config/session"
        ".config/obsidian"
        ".cache/zen"
        ".zen"
#         { directory = ".gnupg"; mode = "0700"; }
#         { directory = ".ssh"; mode = "0700"; }
#         { directory = ".nixops"; mode = "0700"; }
#         { directory = ".local/share/keyrings"; mode = "0700"; }
#         ".local/share/direnv"
#       ".local/share/keyrings"
        ".local/share/onlyoffice"
        ".local/share/kdevelop"
      ]
      ++
      (map(dir:{directory=dir; method="symlink";}) ["Music"])
      ;
      files = [
        ".screenrc"
        ".gtkrc-2.0"
        ".bash_history"
        ".gitconfig"
      ];
      allowOther=true;
    };

    libvirt=links.libvirt;
    plasma=links.plasma;

  };

                  ##    3rd: home.file+mkOutOfStoreSymlink  ##
homeLinks={
  plasma= builtins.listToAttrs(map(x:{name=x; value=let config=config; in {source=config.lib.file.mkOutOfStoreSymlink (settings.paths.dotfiles)/plasma/${x};};})(with links.plasma.user.${plasmaUser};(files++directories)));
};# A set to implement symlinking in home-manager in different manner than persistence module (to be further compared with persistence!)
}
# persistent=persistent;
# }
#   merged = (lib.recursiveUpdate DiscMounts BindMounts);

