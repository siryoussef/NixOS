{ pkgs, settings,... }:

{
  environment.systemPackages = with pkgs; [

  ];

    services = {
        syncthing = {
            enable = true;
            systemService = true;
            user = settings.user.username;
            dataDir = "/Shared"; # "/home/"+settings.user.username+"syncthing";
            configDir = "/Shared/.syncthing"; # "/home/"+settings.user.username+"/syncthing/./config";

        };
    };










}
