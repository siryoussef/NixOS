{ userSettings, /*pkgs, config, lib,  font,  systemSettings,inputs,*/ ...}:
{imports = [
#             ./plasma-manager.nix
          ];
# services={
#   xserver.displayManager = {
#     sddm = {
#       settings = { Autologin = {
#                    Session = "plasmawayland";
#                    User = userSettings.username;
#   }; };
#       settings.Wayland.SessionDir = "${pkgs.plasma5Packages.plasma-workspace}/share/wayland-sessions";
#       #autoLogin.minimumUid = 1000 ;
#       };
#       #job.execCmd = lib.mkForce "exec /run/current-system/sw/bin/sddm";
#   #     };
# };
home.persistence=let storage=import ../../../Storage.nix{inherit userSettings;}; in{${userSettings.persistentStorage}=storage.persistent.plasma.user;};

}
