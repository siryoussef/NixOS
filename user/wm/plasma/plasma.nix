{ settings, config, /*pkgs, config, lib,  font, inputs,*/ ...}:
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
home=let storage=import settings.storagePath{inherit settings config;}; dotfiles= ( (toString settings.flakePath)+"/user/wm/plasma/dotfiles"); in{
    persistence={ ${dotfiles} = storage.persistent.plasma.user;};
#     packages =
# file=storage.homeLinks.plasma;
};
}
