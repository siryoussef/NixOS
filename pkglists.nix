# This file is for central package control, it's target is to make nix package management easier when defining several environments

{pkgs, pkgs-stable,pkgs-kdenlive,...}:
rec{home=(with pkgs; [
    # Nix tools
    fh
    haskellPackages.nix-tree
    nix-du
    graphviz
    nix-web
    nix-top
    nil
    dconf2nix
    # app tools
    appstream
    appstream-glib
    # Core
    unrar
#     alacritty
#     qutebrowser
    microsoft-edge
    teams-for-linux
    tor-browser
    dmenu
    rofi
    syncthing

    zoom-us
    kotatogram-desktop
    kdePackages.neochat
    kdePackages.plasmatube
    whatsapp-for-linux
    beeper

    # Code/text
    vscode-fhs
    #vscodium-fhs
    vim
    wget
    nodePackages.bash-language-server
    github-desktop
    obsidian
    logseq
    jujutsu
    dvc-with-remotes

    # Office
    lyx
    kile
    texstudio
    libreoffice-fresh
    onlyoffice-bin_latest
    kcalc
    mate.atril
    openboard
    xournalpp
    glib
    newsflash
    nautilus
    gnome-calendar
    seahorse
    cheese
    gnome-maps

    openvpn
    protonmail-bridge
    texliveSmall
    numbat

    wine
    bottles
    junest
    qbittorrent
    qdirstat
    # partitioning tools
    duperemove
    btrfs-assistant
    snapper-gui
    gnome-disk-utility
    gparted

  ## USB-flashing
    unetbootin
    ventoy-full
    woeusb-ng
    wimboot

    rclone
    rclone-browser
    grsync
#     yt-dlg # fails to build after updating to python 3.12 as it uses wxpython which is not compatible with python 3.12!!

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
    smplayer
    handbrake
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
    obs-studio-plugins.droidcam-obs
    droidcam
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
#     ardour
#     tenacity
    # Various dev packages
    texinfo
    libffi zlib
    nodePackages.ungit
  ] ++ [ pkgs-kdenlive.kdenlive ]
#   ++ (with pkgs-stable;[ floorp ])
  );
manager= system++[

  ];
system = with pkgs; [

      jre_minimal
      cryptsetup
      home-manager
      devbox

#       nix-doc
#       nix-init
#       nix-diff
#       nix-melt
#       nix-index
#       nix-ld

      nixpkgs-lint-community
      ntfs3g
      pacman
      apt
      aptly
      pmutils
      ## Appimage support (currently broken due to " error : execve : No such file or directory ")
      appimage-run
      appimagekit
      libappimage


      #librewolf
      #chromium
      protonvpn-gui
      pitch-black



      wsysmon
      tldr

      adwaita-icon-theme

      wget
      gcc

      refind
      gnu-efi
      beefi
      ectool

  #     # support both 32- and 64-bit applications
  #     wineWowPackages.stable
  #     # support 32-bit only
  #     wine
  #     # support 64-bit only
  #     (wine.override { wineBuild = "wine64"; })
  #     # support 64-bit only
  #     wine64
  #     # wine-staging (version with experimental features)
  #     wineWowPackages.staging
  #     # winetricks (all versions)
  #     winetricks

      # native wayland support (unstable)
      wineWowPackages.waylandFull
    # xen
    # grub2_xen

    ]
    ++ (with pkgs-stable; [
#     floorp
    efibootmgr
    efitools
    efivar
    exfatprogs
    tmsu
    ]);
virtualisation={
  system=with pkgs; [
  #     virtualbox
      distrobox

      spice spice-gtk
      spice-protocol
      win-virtio
      win-spice

      libguestfs-with-appliance

      dive
      ]
      ++
      (with pkgs-stable;[
      quickemu
      quickgui
      ]);
  user=with pkgs; [
      # Virtual Machines and wine
      libvirt
      virtiofsd
      virt-manager
      virt-manager-qt #(causes an error)
      virter
      virt-viewer
      virt-top
#       virt-what
      qemu
      uefi-run
      # Containers
      lxc
      swtpm
      bottles
      pods
      podman-tui
      podman-desktop
      podman-compose
      boxbuddy
      # Filesystems
      dosfstools

      lxqt.qtermwidget
    ];
};
systemDevEnv=((with pkgs;[
    jupyter-all
    mysqltuner
    mysql-workbench
    pkgs.rPackages.Anaconda
    # grafana
         # = { buildInputs = [ pkgs.qdarkstyle_3_02 ]; }; #( till errors are fixed : qdarkstyle & jedi versions not compatible/ packages not seen by spyder)
    ]) ++
    (with pkgs-stable;[
      devenv
      ]) ++
    (with pkgs;(with python311Packages;[
    ipykernel
    pandas
    numpy
    matplotlib
    spyder
    spyder-kernels
    pyls-spyder
#     qdarkstyle
    ])));
jupyter={
  lab= pkgs.python3.withPackages (p: with p; [
        jupyterhub
        jupyterlab
        ipykernel
        numpy
        pandas
    ]);
  kernels={
    python3= (pkgs.python3.withPackages (pythonPackages: with pythonPackages;[
            jupyter
            jupyterlab-server
            ipykernel
            pandas
            scikit-learn
#             spyder
#             jedi
#             qdarkstyle
#             pyls-spyder
#             spyder-kernels
          ]));
  };
};
shells={
  NixDevEnv= with pkgs-stable;mkShell{
    name = "pip-env"; buildInputs =(with pkgs-stable.python3.pkgs; [
      jupyterlab-git
      jupyterlab-lsp
      jupyterlab-widgets
      jupyter-collaboration
#       # Python requirements (enough to get a virtualenv going).
      psutil
#       tensorflow
#       keras
      pyarrow
      pandas
      matplotlib
#       seaborn
      scikit-learn
#
      ipykernel
#       jupyter # Errors as a built input
      pytest
      setuptools
      wheel
      venvShellHook
      ipython-sql
      sqlalchemy_1_4
      pymysql
      imbalanced-learn
      statsmodels
      clickclick
      click
      openpyxl
      nltk
    ])
    ++ (with pkgs;[
#       azure-cli
      kubectl
      libffi
      openssl
      gcc
      unzip
    ])
    ;
    venvDir = "venv3";
    src = null;
    postVenv = ''
      unset SOURCE_DATE_EPOCH
      ./scripts/install_local_packages.sh
    '';
    postShellHook = ''
      # Allow the use of wheels.
      unset SOURCE_DATE_EPOCH

      # get back nice looking PS1
      source ~/.bashrc
      source <(kubectl completion bash)

      PYTHONPATH=$PWD/$venvDir/${python.sitePackages}:$PYTHONPATH
    '';
  };
};
flatpaks= (map(pkg:{appId = pkg; origin = "flathub";})[
      "io.github._0xzer0x.qurancompanion"
      "io.github.flattool.Warehouse"
      "org.spyder_ide.spyder"
      "org.garudalinux.firedragon"
      "org.jupyter.JupyterLab"
      "page.codeberg.JakobDev.jdFlatpakSnapshot"
      "org.sqlitebrowser.sqlitebrowser"
      "com.github.tchx84.Flatseal"
      "org.gnome.Boxes"
      ]) ++ (map(pkg:{appId = pkg; origin = "flathub-beta";})[
      "org.signal.Signal"

      ]) ++[
      { appId = "com.brave.Browser"; origin = "flathub";  }
#       { appId = "org.signal.Signal"; origin = "flathub-beta";}
#       "com.obsproject.Studio"
#       "im.riot.Riot"
    ];
flatpakRepos= [
      {name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";}
      {name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo";}
      {name = "gnome-nightly"; location = "https://nightly.gnome.org/gnome-nightly.flatpakrepo";}
      ];
}
