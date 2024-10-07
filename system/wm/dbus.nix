{ pkgs, settings, ... }:

{
  services.dbus = {
    enable = true;
#     apparmor="disabled";
    packages = [ pkgs.dconf ];
  };

  programs.dconf = {
    enable = true;
#     packages=[];
    profiles={
      ${settings.user.username}.databases=[
            {
#               path = "/etc/dconf/db/local";
              settings={"org/virt-manager/virt-manager/connections" = {autoconnect = [ "qemu:///system" ]; uris = [ "qemu:///system" ];};
              };
            }
      ];
    };

  };
}
