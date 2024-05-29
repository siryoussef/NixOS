{ config, pkgs, lib, systemSettings, userSettings,... }:

{
  environment.systemPackages = with pkgs; [

  ];

    services = {
        syncthing = {
            enable = true;
            systemService = true;
            user = userSettings.username;
            datadir = "/home/"+userSettings.username+"/syncthing";
            configdir = "/home/"+userSettings.username+"/syncthing/./config";

        };
    };










}
