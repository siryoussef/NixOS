
{ config, pkgs, pkgs-stable, pkgs-r2211, pkgs-emacs, pkgs-kdenlive, systemSettings, ... }:
let
pkglists={
  UnStable = with pkgs; [
      vim
      wget
      zsh
      git
      cryptsetup
      home-manager
  #   thorium-avx
  #     fish
  #     babelfish
  #     bashInteractiveFHS
      appstream
      appstream-glib
      haskellPackages.nix-tree
      firejail
      /*
      nix-top
      nix-doc
      nix-init
      nix-diff
      nix-melt
      nix-index
      nix-ld
      */
      nixpkgs-lint-community
      ntfs3g
      pacman
      apt
      aptly
      pmutils
      ## Appimage support (currently broken due to " error : execve : No such file or directory ")
      appimage-run
      appimagekit
      libappimage

      distrobox
      gnome.gnome-disk-utility
      gparted
      duperemove
      btrfs-assistant
      snapper-gui
      #librewolf
      #chromium
      protonvpn-gui
      pitch-black
      vlc
      smplayer
      obs-studio
      handbrake

      rclone
      rclone-browser
      syncthing
      syncthing-tray
      grsync
      unrar

      wsysmon
      tldr
      kcalc
      unetbootin
      ventoy-full
      woeusb-ng
      wimboot
      gnome.adwaita-icon-theme

      wget
      gcc

      refind
      gnu-efi
      beefi
      ectool

  #     # support both 32- and 64-bit applications
  #     wineWowPackages.stable
  #     # support 32-bit only
  #     wine
  #     # support 64-bit only
  #     (wine.override { wineBuild = "wine64"; })
  #     # support 64-bit only
  #     wine64
  #     # wine-staging (version with experimental features)
  #     wineWowPackages.staging
  #     # winetricks (all versions)
  #     winetricks

      # native wayland support (unstable)
      wineWowPackages.waylandFull
    # xen
    # grub2_xen

    ];
    Stable = with pkgs-stable; [
#     floorp
    efibootmgr
    efitools
    efivar
    ];
    };

in {
#     pkgSettings = {
#         systemPackages = (systemSettings.profile).system.packages;
#         homePackages = (systemSettings.profile).home.packages;
#         };

environment = {
  shells = with pkgs; [ fish zsh bash ];
  sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  # List packages installed in system profile.
  systemPackages = with pkglists;(UnStable ++ Stable);

 };
 }

