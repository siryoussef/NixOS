{ config, pkgs, pkgs-stable, pkgs-r2211, pkgs-emacs, pkgs-kdenlive, systemSettings, inputs, userSettings, lib, ... }:
# let
# pkglists = import ../../pkglists.nix;
# homepkgs = pkglists.home;
# in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = userSettings.username;
    homeDirectory = "/home/"+userSettings.username;
    stateVersion = "24.05"; # Please read the comment before changing.
#     packages = homepkgs;
    sessionVariables = {
      EDITOR = userSettings.editor;
      SPAWNEDITOR = userSettings.spawnEditor;
      TERM = userSettings.term;
      BROWSER = userSettings.browser;
      };
    };

  programs = { home-manager.enable = true;
    thunderbird={ enable = true;
#       package = pkgs.betterbird;
      profiles = {
        "Main"={

          isDefault = true;
          withExternalGnupg = true;


  };};};};
  imports = [
#               (if ((userSettings.editor == "emacs") || (userSettings.editor == "emacsclient")) then inputs.nix-doom-emacs.hmModule else null)
#               stylix.homeManagerModules.stylix
             (./. + "../../../user/wm"+("/"+userSettings.wm+"/"+userSettings.wm)+".nix") # My window manager selected from flake
              ../../user/shell/sh.nix # My zsh and bash config
              ../../user/shell/cli-collection.nix # Useful CLI apps
              ../../user/bin/phoenix.nix # My nix command wrapper
#               ../../user/app/doom-emacs/doom.nix # My doom emacs config
              ../../user/app/ranger/ranger.nix # My ranger file manager config
              ../../user/app/git/git.nix # My git config
#               ../../user/app/keepass/keepass.nix # My password manager
              (./. + "../../../user/app/browser"+("/"+userSettings.browser)+".nix") # My default browser selected from flake
              ../../user/app/virtualization/virtualization.nix # Virtual machines
              #../../user/app/AI/chat-gpt-retrieval-plugin.nix
              #../../user/app/AI/ollama.nix
              #../../user/app/flatpak/flatpak.nix # Flatpaks
              #../../user/style/stylix.nix # Styling and themes for my apps
              ../../user/lang/cc/cc.nix # C and C++ tools
#               ../../user/lang/godot/godot.nix # Game development
              #../../user/pkgs/blockbench.nix # Blockbench ## marked as insecure
              ../../user/hardware/bluetooth.nix # Bluetooth
              ./homepkgs.nix
#               ../../pkglists.nix
#         inputs.impermanence.nixosModules.home-manager.impermanence

            ];


  services.syncthing.enable = true;

xdg = {
  enable = true;
  userDirs = {
    enable = true;
    createDirectories = true;
    music = "${config.home.homeDirectory}/Media/Music";
    videos = "${config.home.homeDirectory}/Media/Videos";
    pictures = "${config.home.homeDirectory}/Media/Pictures";
    templates = "${config.home.homeDirectory}/Templates";
    download = "${config.home.homeDirectory}/Downloads";
    documents = "${config.home.homeDirectory}/Documents";
    desktop = null;
    publicShare = null;
    extraConfig = {
      XDG_DOTFILES_DIR = "${config.home.homeDirectory}/.dotfiles";
      XDG_ARCHIVE_DIR = "${config.home.homeDirectory}/Archive";
      XDG_VM_DIR = "${config.home.homeDirectory}/Machines";
      XDG_ORG_DIR = "${config.home.homeDirectory}/Org";
      XDG_PODCAST_DIR = "${config.home.homeDirectory}/Media/Podcasts";
      XDG_BOOK_DIR = "${config.home.homeDirectory}/Media/Books";
    };
  };
   mime.enable = true;
          mimeApps = { enable = true; /* associations.added = { "application/octet-stream" = "flstudio.desktop;";};*/ };
          };
home.persistence= let storage= import ../../Storage.nix{inherit userSettings;};  in{
  ${userSettings.persistentStorage}=storage.persistent.user;
};




}
