{ config, pkgs, nix-doom-emacs, stylix, settings, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = settings.user.username;
  home.homeDirectory = "/home/"+settings.user.username;

  programs.home-manager.enable = true;

  imports = [
              (if ((settings.user.editor == "emacs") || (settings.user.editor == "emacsclient")) then nix-doom-emacs.hmModule else null)
              stylix.homeManagerModules.stylix
              ../../user/shell/sh.nix # My zsh and bash config
              ../../user/shell/cli-collection.nix # Useful CLI apps
              ../../user/bin/phoenix.nix # My nix command wrapper
              ../../user/app/doom-emacs/doom.nix # My doom emacs config
              ../../user/app/ranger/ranger.nix # My ranger file manager config
              ../../user/app/git/git.nix # My git config
              ../../user/style/stylix.nix # Styling and themes for my apps
              ../../user/lang/cc/cc.nix # C and C++ tools
            ];

  home.stateVersion = "22.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # Core
    zsh
    git
    syncthing

    # Office
    libreoffice-fresh

    # Various dev packages
    texinfo
    libffi zlib
    nodePackages.ungit
  ];

  xdg.enable = true;
  xdg.userDirs = {
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
      XDG_ORG_DIR = "${config.home.homeDirectory}/Org";
      XDG_BOOK_DIR = "${config.home.homeDirectory}/Media/Books";
    };
  };
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  home.sessionVariables = {
    EDITOR = settings.user.editor;
  };

}
