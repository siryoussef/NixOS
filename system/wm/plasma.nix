{ config, lib, pkgs, pkgs-stable, ... }:
{
imports = [
            ./wayland.nix
            ./pipewire.nix
            ./dbus.nix
          ];
  i18n.inputMethod.fcitx5.plasma6Support = config.services.desktopManager.plasma6.enable ;
  services = {
#     xserver = {
#
#       desktopManager = {
#         plasma5 = {
#           enable = false;
#           phononBackend = "vlc";
#           runUsingSystemd = true;
#           useQtScaling = true;
#           };
#         };
#       };

    displayManager = {
        autoLogin={enable = true; /* user="";*/};
        defaultSession = "plasma"; # plasma for plasma6 on wayland , plasmax11 for plasma6 on x11 (was plasmawayland & plasma on plasma5)
        preStart = "";
        sddm = {
          enable = true;
          enableHidpi = true;
          autoLogin={relogin = true; minimumUid = 1000;};
          autoNumlock = true;
          wayland.enable = true ;

          #autoLogin.minimumUid = 1000 ;
          #settings.Wayland.SessionDir = "${pkgs.plasma5Packages.plasma-workspace}/share/wayland-sessions";
          };
        };

    desktopManager = {
        plasma6 = {
          enable = true;
          notoPackage = pkgs.noto-fonts;
          enableQt5Integration = true;
          };
        };
  spice-vdagentd.enable = true ;
  gnome.gnome-keyring.enable = true;
  gnome.gnome-online-accounts.enable = true;
  gvfs.enable = true;
  devmon.enable = true;
  udisks2.enable = true;
  };

  # Security
  security = {
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
#    pam.services.gtklock = {};
    pam.services.login.enableGnomeKeyring = true;
  };

environment = {
  plasma5.excludePackages = [ /* pkgs.elisa */ ];
  plasma6.excludePackages = [ /* pkgs.elisa */ ];
  systemPackages = ((with pkgs; [
    gnome.gnome-control-center
    plasma-hud
    systemdgenie
   # plasma-browser-integration
    libreoffice-qt
    krusader
    gsignondPlugins.oauth
    pcmanfm-qt

  ]) ++ (with pkgs; (with kdePackages;[
    kate
    kcalc
    kio
    kio-gdrive
    kio-fuse
    kio-admin
    kio-extras
    kio-extras-kf5
    kio-zeroconf
    audiocd-kio
    kdesdk-kio
    plasma5support
    kcmutils
    sddm-kcm
    kcmutils
    flatpak-kcm
    kpipewire
    plymouth-kcm
    plasma-disks
    filelight
    kdenlive
    neochat
    appstream-qt
    kmailtransport
    kaccounts-providers
    kaccounts-integration
    signond
    signon-kwallet-extension
#     kdevelop kdev-python
    discover
    ]))

#   ++ (with pkgs-stable;(with kdePackages;[ kdevelop kdev-python ]))

  ++ (with pkgs;(with libsForQt5;[
    kdevelop kdev-python
    qmltermwidget
    libkomparediff2
    ]))) ;
};

  programs = {
    chromium = {
      enablePlasmaBrowserIntegration = true;
      #plasmaBrowserIntegrationPackage = pkgs.plasma-browser-integration;
    };

  };
}
