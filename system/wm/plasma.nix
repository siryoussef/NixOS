{ config, lib, pkgs, pkgs-stable, settings, ... }:
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
          theme = "chili";

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
  gnome.gnome-keyring.enable = true;
  gnome.gnome-online-accounts.enable = true;
  gvfs.enable = true;
  devmon.enable = true;
  udisks2.enable = true;
  };

  # Security
  security = {
    pam.services={
      swaylock = {
        text = ''
          auth include login
        '';
      };
  #    pam.services.gtklock = {};
      login.enableGnomeKeyring = true;
      ${settings.user.username}.kwallet.enable=true;
    };
  };

environment = {
  plasma5.excludePackages = [ /* pkgs.elisa */ ];
  plasma6.excludePackages = [ /* pkgs.elisa */ ];
  systemPackages = settings.pkglists.plasma.system;
};

  programs = {
    chromium = {
      enablePlasmaBrowserIntegration = true;
      #plasmaBrowserIntegrationPackage = pkgs.plasma-browser-integration;
    };

  };
}
