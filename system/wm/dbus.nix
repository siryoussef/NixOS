{ pkgs, settings, ... }:

{
  services.dbus = {
    enable = true;
    apparmor=false;
    packages = [ pkgs.dconf ];
  };

  programs.dconf = {
    enable = true;
#     packages=[];
#     profiles={${settings.user.username}.databases=[{settings={};}];};

  };
}
