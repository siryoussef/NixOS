{ config, pkgs, pkgs-stable, pkgs-r2211, pkgs-emacs, pkgs-kdenlive, settings, inputs, lib, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = let storage= import settings.paths.storage{inherit settings config;}; list=import settings.paths.pkglists{inherit pkgs pkgs-stable pkgs-kdenlive;}; in {
    username = settings.user.username;
    homeDirectory = "/home/"+settings.user.username;
    stateVersion = "24.05"; # Please read the comment before changing.
#     packages = homepkgs;
    sessionVariables = {
      EDITOR = settings.user.editor;
      SPAWNEDITOR = settings.user.spawnEditor;
      TERM = settings.user.term;
      BROWSER = settings.user.browser;
      };
#     persistence =storage.persistent.user;
    packages = list.home ++[inputs.system-manager.packages.${settings.system.arch}.system-manager];
    file=storage.homeLinks.user;
#     file.".config/kdedefaults".source= config.lib.file.mkOutOfStoreSymlink ./user/wm/plasma/dotfiles/kdedefaults;
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
#               (if ((settings.user.editor == "emacs") || (settings.user.editor == "emacsclient")) then inputs.nix-doom-emacs.hmModule else null)
#               inputs.stylix.homeManagerModules.stylix
             (./. + "../../../user/wm"+("/"+settings.user.wm+"/"+settings.user.wm)+".nix") # My window manager selected from flake
              ../../user/shell/sh.nix # My zsh and bash config
              ../../user/shell/cli-collection.nix # Useful CLI apps
#               ../../user/bin/phoenix.nix # My nix command wrapper
#               ../../user/app/doom-emacs/doom.nix # My doom emacs config
              ../../user/app/nvim/nvim.nix # My doom emacs config
              #../../user/app/emacsng # Me experimenting with emacsng and a vanilla config
              ../../user/app/ranger/ranger.nix # My ranger file manager config
              ../../user/app/git/git.nix # My git config
#               ../../user/app/keepass/keepass.nix # My password manager
              (./. + "../../../user/app/browser"+("/"+settings.user.browser)+".nix") # My default browser selected from flake
              ../../user/app/virtualization/virtualization.nix # Virtual machines
              #../../user/app/AI/chat-gpt-retrieval-plugin.nix
              #../../user/app/AI/ollama.nix
              #../../user/app/flatpak/flatpak.nix # Flatpaks
#               ../../user/style/stylix.nix # Styling and themes for my apps
              ../../user/lang/cc/cc.nix # C and C++ tools
#               ../../user/lang/godot/godot.nix # Game development
              #../../user/pkgs/blockbench.nix # Blockbench ## marked as insecure
              ../../user/hardware/bluetooth.nix # Bluetooth

            ];


#   services.syncthing={ enable = true; tray.enable=true;};

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





}
