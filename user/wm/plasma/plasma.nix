{ settings, config, /*pkgs, config, lib,  font, inputs,*/ ...}:
{imports = [
#             ./plasma-manager.nix
          ];
# services={
#   xserver.displayManager = {
#     sddm = {
#       settings = { Autologin = {
#                    Session = "plasmawayland";
#                    User = settings.user.username;
#   }; };
#       settings.Wayland.SessionDir = "${pkgs.plasma5Packages.plasma-workspace}/share/wayland-sessions";
#       #autoLogin.minimumUid = 1000 ;
#       };
#       #job.execCmd = lib.mkForce "exec /run/current-system/sw/bin/sddm";
#   #     };
# };
home=let storage=import settings.paths.storage{inherit settings config;};  in{
#     persistence=storage.persistent.plasma.user;
    file=storage.homeLinks.plasma;
     packages = settings.pkglists.plasma.user;
};
}
