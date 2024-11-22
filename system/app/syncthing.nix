{ pkgs, settings,... }:

{
  environment.systemPackages = with pkgs; [

  ];

    services = {
        syncthing = {
            enable = true;
            guiAddress="127.0.0.1:8384";
            openDefaultPorts=true;
            systemService = true;
            user = settings.user.username;
            dataDir = "/Shared"; # "/home/"+settings.user.username+"syncthing";
            configDir = "/Shared/.syncthing"; # "/home/"+settings.user.username+"/syncthing/./config";
            key=null; cert=null;
            relay={
              enable=true;
              port=22067;
              statusPort=22070;
              statusListenAddress="";
              providedBy=settings.user.username;
              pools=null; # Relay pools to join. If null, uses the default global pool
              listenAddress=""; # Address to listen on for relay traffic
              globalRateBps=null; # global rate limit
              perSessionRateBps=null; # per-session rate limit
              extraOptions=[];
            };
            settings={
              gui = { theme = "black";};
              options = {
                localAnnounceEnabled = false;
                maxFolderConcurrency=null;
              };
              folders={
                Downloads={
                  id="Download";
                  path="~/Downloads";
                  devices=["YTank"];
                  type="sendreceive"; # one of "sendreceive", "sendonly", "receiveonly", "receiveencrypted"
                  copyOwnershipFromParent=false;
                  versioning = null; /*[
                        {versioning={type ="simple"; params.keep = "10";}; }
                        {versioning={type ="trashcan"; params.cleanoutDays = "1000";};}
                        {versioning={type ="staggered"; fsPath = "/syncthing/backup"; params = { cleanInterval = "3600"; maxAge = "31536000";};};}
                        {versioning = {type = "external"; params.versionsPath = pkgs.writers.writeBash "backup" ''
                                folderpath="$1"
                                filepath="$2"
                                rm -rf "$folderpath/$filepath"
                              '';
                            };
                        }
                        ]*/
                };
                Note={
                  id="Note";
                  path="~/Note";
                  devices=["YTank"];
                  type="sendreceive"; # one of "sendreceive", "sendonly", "receiveonly", "receiveencrypted"
                  copyOwnershipFromParent=false;
                  versioning = null; /*[
                        {versioning={type ="simple"; params.keep = "10";}; }
                        {versioning={type ="trashcan"; params.cleanoutDays = "1000";};}
                        {versioning={type ="staggered"; fsPath = "/syncthing/backup"; params = { cleanInterval = "3600"; maxAge = "31536000";};};}
                        {versioning = {type = "external"; params.versionsPath = pkgs.writers.writeBash "backup" ''
                                folderpath="$1"
                                filepath="$2"
                                rm -rf "$folderpath/$filepath"
                              '';
                            };
                        }
                        ]*/
                };
              };
              overrideFolders=false;
              devices={
                "YTank"={
                  id= "SJH57WL-M6UVVPV-4YWV3DC-MRXL7WX-BHOLRXM-JIW5YP5-BGHVVH4-SVNP4AG";
                  autoAcceptFolders=false;

                };
              };
              overrideDevices=false;
            };
        };
    };

}
