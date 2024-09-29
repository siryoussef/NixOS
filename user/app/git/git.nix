{ config, pkgs, settings, ... }:

{
  home.packages = [ pkgs.git ];
  programs.git={enable = true; userName = settings.user.name; userEmail = settings.user.email; extraConfig = {
    init.defaultBranch = "main";
    safe.directory = [ ("/home/" + settings.user.username + "/.dotfiles")
                       ("/home/" + settings.user.username + "/.dotfiles/.git") ];
    };
  };
}
