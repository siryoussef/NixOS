{ config, lib, pkgs, font, plasma-manager, userSettings, systemSettings, ... }:

{
  # Import wayland config
  imports = [
            ];

 services.xserver.displayManager = {
    sddm = {
      settings = { Autologin = {
                   Session = "plasmawayland";
                   User = userSettings.username;
  }; };
      settings.Wayland.SessionDir = "${pkgs.plasma5Packages.plasma-workspace}/share/wayland-sessions";
      #autoLogin.minimumUid = 1000 ;
      };
      #job.execCmd = lib.mkForce "exec /run/current-system/sw/bin/sddm";
      };
}
