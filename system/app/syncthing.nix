{ config, pkgs, lib, systemSettings, userSettings,... }:

{
  environment.systemPackages = with pkgs; [

  ];

    services = {
        syncthing = {
            enable = true;
            systemService = true;
            user = userSettings.username;
            dataDir = "/home/"+userSettings.username+"/syncthing";
            configDir = "/home/"+userSettings.username+"/syncthing/./config";

        };
    };










}
