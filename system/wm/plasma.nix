{ config, lib, pkgs, pkgs-stable, font, plasma-manager, ... }:
{
imports = [
            ./wayland.nix
            ./pipewire.nix
            ./dbus.nix
          ];
  i18n.inputMethod.fcitx5.plasma6Support = config.services.desktopManager.plasma6.enable ;
  services = {
    xserver = {

      desktopManager = {
        plasma5 = {
          enable = false;
          phononBackend = "vlc";
          runUsingSystemd = true;
          useQtScaling = true;
          };
        };
      };

    displayManager = {
        #autoLogin.enable = true;
        defaultSession = "plasma"; # plasma for plasma6 on wayland , plasmax11 for plasma6 on x11 (was plasmawayland & plasma on plasma5)
        sddm = {
          enable = true;
          enableHidpi = true;
          autoLogin.relogin = true;
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
  plasma5.excludePackages = [ /* pkgs.kdePackages.elisa */ ];
  plasma6.excludePackages = [ /* pkgs.kdePackages.elisa */ ];
  systemPackages = with pkgs;/*with pkgs-stable*/ [
    kdePackages.plasma5support
    plasma-hud
    kdePackages.kcmutils
    kdePackages.sddm-kcm
    kdePackages.kcmutils
    kdePackages.flatpak-kcm
    kdePackages.plymouth-kcm
    kate
   # plasma-browser-integration
    kdePackages.plasma-disks
    kdePackages.filelight
    kdePackages.kdenlive
    kdePackages.neochat
    kdePackages.appstream-qt
    libsForQt5.qmltermwidget
    libsForQt5.discover
    libreoffice-qt
    krusader
    kcalc
#     kdePackages.kdevelop
#     kdePackages.kdev-python
    libsForQt5.kdevelop
    libsForQt5.kdev-python
  ];
};

  programs = {
    chromium = {
      enablePlasmaBrowserIntegration = true;
      #plasmaBrowserIntegrationPackage = pkgs.kdePackages.plasma-browser-integration;
    };

  };
}
