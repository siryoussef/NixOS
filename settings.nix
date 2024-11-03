{pkgs', inputs,...}:
rec{
inherit inputs pkgs';
settings = {inherit inputs pkgs' system user paths;};
  # ---- SYSTEM SETTINGS ---- #
system = rec{
        arch = "x86_64-linux"; # system arch
        system=arch; #for backward combatibility (to be removed)
        hostname = "Snowyfrank"; # hostname
        profile = "work"; # select a profile defined from my profiles directory
        timezone = "Africa/Cairo"; # select timezone
        locale = "en_US.UTF-8"; # select locale
        bootMode = "uefi"; # uefi or bios
        bootMountPath = "/boot/efi"; # mount path for efi boot partition; only used for uefi boot mode
        grubDevice = "/dev/disk/by-label/Boot"; # device identifier for grub; only used for legacy (bios) boot mode
        persistentStorage ="/Shared/@Persistent";
      };
  # ----- USER SETTINGS ----- #
user = rec {
        username = "youssef"; # username
        name = "Youssef"; # name/identifier
        email = "youssef@disroot.org"; # email (used for certain configurations)
        dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
        theme = "uwunicorn-yt"; # selcted theme from my themes directory (./themes/)
        wm = "plasma"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
        # window manager type (hyprland or x11) translator
        wmType = if (wm == "hyprland") || (wm == "plasma") then "wayland" else "x11";
        browser = "floorp"; # Default browser; must select one from ./user/app/browser/
        defaultRoamDir = "Personal.p"; # Default org roam directory relative to ~/Org
        term = "konsole"; # Default terminal command;
        font = "Intel One Mono"; # Selected font
        fontPkg = pkgs'.main.intel-one-mono; # Font package
        editor =  "kate";  #"emacsclient"; # Default editor;
        # editor spawning translator
        # generates a command that can be used to spawn editor inside a gui
        # EDITOR and TERM session variables must be set in home.nix or other module
        # I set the session variable SPAWNEDITOR to this in my home.nix for convenience
        spawnEditor = if (editor == "emacsclient") then
                        "emacsclient -c -a 'emacs'"
                      else
                        (if ((editor == "vim") ||
                             (editor == "nvim") ||
                             (editor == "nano")) then
                               "exec " + term + " -e " + editor
                         else
                           editor);
        persistentStorage = "/Shared/@Persistent/home/"+"${username}";
      };
paths={
      pkglists = builtins.path{path=./pkglists.nix;};
      storage = builtins.path{path=./Storage.nix;};
      flake=/etc/nixos;
      dotfiles= /. + "/Shared/@Repo/dotfiles";
      };
pkglists=import paths.pkglists{inherit settings;};
storage= let config=config; in /*import ./settings.nix;*/ import paths.storage{inherit settings config;}; #FIXME GiveUp improving it or putting it in settings or Replace mkOutOfStoreSymlink (~ reimplement it or wait for impermanence fix to work outside nixos) or find a method import config from outside (worst trial!).

}


