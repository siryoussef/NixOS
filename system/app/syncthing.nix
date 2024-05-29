{ config, pkgs, lib, systemSettings, userSettings,... }:

{
  environment.systemPackages = with pkgs; [

  ];

    services = {
        syncthing = {
            enable = true;
            systemService = true;
            user = userSettings.username;
            dataDir = "/Shared"; # "/home/"+userSettings.username+"syncthing";
            configDir = "/Shared/.syncthing"; # "/home/"+userSettings.username+"/syncthing/./config";

        };
    };










}
