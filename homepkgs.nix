{ config, pkgs, pkgs-stable, pkgs-r2211, pkgs-emacs, pkgs-kdenlive, systemSettings, ... }:
{home.packages = (with pkgs; [
    # Core
    zsh
#     alacritty
#     qutebrowser
    microsoft-edge
    tor-browser
    dmenu
    rofi
    git
    syncthing

    zoom-us
    kotatogram-desktop
    kdePackages.neochat
    kdePackages.plasmatube
    whatsapp-for-linux
    beeper
    vscode-fhs
    betterbird-unwrapped
    #vscodium-fhs
    github-desktop
    obsidian
    logseq

    # Office
    libreoffice-fresh
    onlyoffice-bin_latest
    mate.atril
    openboard
    xournalpp
    glib
    newsflash
    gnome.nautilus
    gnome.gnome-calendar
    gnome.seahorse
    gnome.gnome-maps
    openvpn
    protonmail-bridge
    texliveSmall
    numbat

    wine
    bottles
    qbittorrent
    yt-dlg
    # The following requires 64-bit FL Studio (FL64) to be installed to a bottle
    # With a bottle name of "FL Studio"
    /*
    (pkgs.writeShellScriptBin "flstudio" ''
       #!/bin/sh
       if [ -z "$1" ]
         then
           bottles-cli run -b "FL Studio" -p FL64
           #flatpak run --command=bottles-cli com.usebottles.bottles run -b FL\ Studio -p FL64
         else
           filepath=$(winepath --windows "$1")
           echo \'"$filepath"\'
           bottles-cli run -b "FL Studio" -p "FL64" --args \'"$filepath"\'
           #flatpak run --command=bottles-cli com.usebottles.bottles run -b FL\ Studio -p FL64 -args "$filepath"
         fi
    '')
    (pkgs.makeDesktopItem {
      name = "flstudio";
      desktopName = "FL Studio 64";
      exec = "flstudio %U";
      terminal = false;
      type = "Application";
      mimeTypes = ["application/octet-stream"];
    })
  */
    # Media
    gimp
#     pinta
    krita
    inkscape
#     musikcube
    vlc
    vlc-bittorrent
#     mpv
    yt-dlp
#     blender
    /*
    cura
    curaengine_stable
    (stdenv.mkDerivation {
      name = "cura-slicer";
      version = "0.0.7";
      src = fetchFromGitHub {
        owner = "Spiritdude";
        repo = "Cura-CLI-Wrapper";
        rev = "ff076db33cfefb770e1824461a6336288f9459c7";
        sha256 = "sha256-BkvdlqUqoTYEJpCCT3Utq+ZBU7g45JZFJjGhFEXPXi4=";
      };
      phases = "installPhase";
      installPhase = ''
        mkdir -p $out $out/bin $out/share $out/share/cura-slicer
        cp $src/cura-slicer $out/bin
        cp $src/settings/fdmprinter.def.json $out/share/cura-slicer
        cp $src/settings/base.ini $out/share/cura-slicer
        sed -i 's+#!/usr/bin/perl+#! /usr/bin/env nix-shell\n#! nix-shell -i perl -p perl538 perl538Packages.JSON+g' $out/bin/cura-slicer
        sed -i 's+/usr/share+/home/${userSettings.username}/.nix-profile/share+g' $out/bin/cura-slicer
      '';
      propagatedBuildInputs = with pkgs; [
        curaengine_stable
      ];
    })
    */
    obs-studio
    ffmpeg
    (pkgs.writeScriptBin "kdenlive-accel" ''
      #!/bin/sh
      DRI_PRIME=0 kdenlive "$1"
    '')
    movit
    mediainfo
    libmediainfo
    mediainfo-gui
    audio-recorder
    gnome.cheese
#     ardour
#     tenacity

    # Various dev packages
    texinfo
    libffi zlib
    nodePackages.ungit
  ] ++ [ pkgs-kdenlive.kdenlive ]
  ++ (with pkgs-stable;[
#   floorp
  ]));
  }
