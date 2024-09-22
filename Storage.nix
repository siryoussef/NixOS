{  userSettings, ... }:
rec{
DiscMounts = rec{
    "/" = { device = "none"; fsType = "tmpfs"; /*options=["mode=777"];*/}; # In-RAM-Root
#     "/" = { device = "/dev/disk/by-label/NRoot"; fsType = "btrfs"; };
    "/nix" = { device = "/dev/disk/by-label/Nix"; fsType = "ext4"; depends = ["/" "/home"];};
    "/boot" = { device = "/dev/disk/by-label/Boot"; fsType = "btrfs"; options = [ "subvol=@Nix" ]; };
#     "/home" = { device = "/dev/disk/by-label/Home"; fsType = "btrfs"; options =["subvol=@NHome"];};
#       Home={mountPoint= "/home/" + userSettings.username; device = "none"; fsType = "tmpfs"; options = [/*"rw" "user" */ "uid=${userSettings.username}" "gid=users" "mode=777"]; depends = ["/"]; };# In-RAM-Home

    "/Volume" = { device = "/dev/disk/by-label/Volume"; fsType = "auto"; };
    "/Shared" = { device = "/dev/disk/by-label/Shared"; fsType = "auto"; neededForBoot=true; };
    "/boot/efi" = { device = "/dev/disk/by-label/BEFI"; fsType = "vfat"; };
     }
     //(builtins.mapAttrs(x: y: y // {device = "none"; fsType = "tmpfs"; options = [/*"rw" "user" */ "uid=${userSettings.username}" "gid=users" "mode=777"]; depends = ["/"];})rec{
     Home={mountPoint= "/home/" + userSettings.username;};
     local={mountPoint=Home.mountPoint+"/.local";};
     local-share={mountPoint=local.mountPoint+"/share";};
     cache={mountPoint=Home.mountPoint+"/.cache";};
     config={mountPoint=Home.mountPoint+"/.config";};

     })
     ;
BindMounts =(builtins.mapAttrs(x: y: y // {fsType = "none"; options=["bind" "mode=777"];}) rec{
  "/etc/nixos" = { device = "/Shared/@Repo/NixOS";};
  "/etc/nixos/secrets" = { device = "/Shared/@Repo/NixOS-private";};
  Downloads = { mountPoint = "/home/"+userSettings.username+"/Downloads"; device = "/Volume/@Storage/Downloads"; depends = [ "/" "/home" "/Volume"]; };
  vscode= {mountPoint = "/home/"+userSettings.username+"/.vscode"; device = "/Shared/@Home/.vscode";};
  fish={mountPoint = "/home/"+userSettings.username+"/.local/share/fish"; device = "/Shared/@Home/fish";};
  kate={mountPoint = "/home/"+userSettings.username+"/.local/share/kate"; device = "/Shared/@Home/kate";};
  kdevelop={mountPoint = "/home/"+userSettings.username+"/.local/share/kdevelop"; device = "/Shared/@Home/kdevelop";};
  onlyoffice={mountPoint = "/home/"+userSettings.username+"/.local/share/onlyoffice"; device = "/Shared/@Home/onlyoffice";};
  whatsapp-for-linux={ mountPoint = "/home/"+userSettings.username+"/.local/share/whatsapp-for-linux"; device = "/Shared/@Home/whatsapp-for-linux";};
  KotatogramDesktop={mountPoint = "/home/"+userSettings.username+"/.local/share/KotatogramDesktop"; device = "/Shared/@Home/KotatogramDesktop";};
  Github={mountPoint = "/home/"+userSettings.username+"/.config/GitHub Desktop"; device = "/Shared/@Home/.config/GitHub Desktop";};
  GitRepos= {mountPoint = "/home/"+userSettings.username+"/Documents/GitHub"; device = "/Shared/@Repo";};
  logseq= {mountPoint = "/home/"+userSettings.username+"/.logseq"; device = "/Shared/@Repo/Note/.logseq";};
  Note= {mountPoint = "/home/"+userSettings.username+"/Note"; device = "/Shared/@Repo/Note";};

   ## Flatpak bind mounts
  "/var/lib/flatpak" ={device = "/Shared/flatpak/system";};
  User-flatpaks ={mountPoint="/home/"+userSettings.username+"/.local/share/flatpak";device = "/Shared/flatpak/user";};
  FlatpakAppData ={mountPoint="/home/"+userSettings.username+"/.var/app";device = "/Shared/flatpak/appdata";};

  ## WebBrowsers
  floorp= { mountPoint = "/home/"+userSettings.username+"/.floorp"; device = "/Shared/@Home/.floorp";  };
  firedragonFlatpakProfiles={mountPoint= FlatpakAppData.mountPoint+"/org.garudalinux.firedragon/.firedragon"; device = floorp.device;};
  firedragonProfiles={mountPoint= "/home/"+userSettings.username+"/.firedragon"; device = floorp.device;};

   ## Waydroid
  waydroidData={ mountPoint = "/home/"+userSettings.username+"/.local/share/waydroid"; device = "/Shared/@Home/waydroid/waydroidData";};
  waydroidSystem={ mountPoint = "/var/lib/waydroid"; device = "/Shared/@Home/waydroid/waydroidSystem"; };
  waydroidDownloadsShareMain= { mountPoint = "/home/"+userSettings.username+"/.local/share/waydroid/data/media/0/Download"; device = "/home/"+userSettings.username+"/Downloads"; depends = [ "/" "/home" "/Volume" ] ++ (map(x: "${x.mountPoint}")[Downloads waydroidData]); }; #could be simpler without the map function if one variable & may work perfectly without the depends option at all ! ,  but this is for educatory purposes to help in future modifications

   ## Plasma config files!!
#    kateConfig={ mountPoint = "/home/"+userSettings.username+"/.config/kate"; device = "/Shared/@Home/.config/kate";  };
  });
## Overlayfs
persistent={
	system={
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
    user= {
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
        ".android"
        ".config/kdeconnect"
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
      ]
      ++
      (map(dir:{directory=dir; method="symlink";}) ["Music"])
      ;
      files = [
        ".config/katerc"
        ".config/gtkrc"
        ".config/dolphinrc"
        ".config/kwinrc"
        ".screenrc"
        ".gtkrc-2.0"
        ".bash_history"
        ".gitconfig"
        ".config/kdeglobals"
        ".config/kwinrulesrc"
      ];
      allowOther=true;
    };
  };


#   merged = (lib.recursiveUpdate DiscMounts BindMounts);
fileSystems = DiscMounts//BindMounts;
}
# in {inherit fileSystems;
# persistent=persistent;
# }
