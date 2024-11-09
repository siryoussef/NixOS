# This file is for central package control, it's target is to make nix package management easier when defining several environments

{settings,...}:
let
inputs=settings.inputs;
pkgs'=settings.pkgs'; pkgs=pkgs'.main; pkgs-stable=pkgs'.stable;
in
rec{

  home=(with pkgs'.unstable; [
    # Nix tools
    fh
    haskellPackages.nix-tree
    nix-du
    graphviz
    nix-web
    nix-top
    nil
    dconf2nix
#     nixfmt-rfc-style
    alejandra
 
    # app tools
    appstream
    appstream-glib
    # Core
    unrar
    bindfs
#     alacritty
#     qutebrowser
    microsoft-edge
    teams-for-linux
    tor-browser
    dmenu
    rofi
    zoom-us
    kotatogram-desktop
    kdePackages.neochat #FIXME "olm-3.2.16" ~ insecure!
    whatsapp-for-linux
    beeper

    # Code/text
    vim
    wget
    nodePackages.bash-language-server
    github-desktop
    # (pkgs.writeScriptBin "github-desktop-wrapped" ''
    #   #!/bin/sh
    #   export PATH=${pkgs.vscode}/bin:$PATH
    #   exec ${pkgs.github-desktop}/bin/github-desktop "$@"
    # '')
    # (pkgs.writeShellApplication {
    #   name = "github-desktop-wrapped";
    #   executable = "${pkgs.github-desktop}/bin/github-desktop";
    #   runtimeInputs = [ vscode ];
    # })
    obsidian
    logseq
    jujutsu

    # Office
    lyx
    kile
    texstudio
    libreoffice-fresh
    onlyoffice-bin_latest
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
        sed -i 's+/usr/share+/home/${settings.user.username}/.nix-profile/share+g' $out/bin/cura-slicer
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
  ] ++ [ pkgs'.kdenlive ]
  ++ (with pkgs'.stable;[
#     floorp
    dvc-with-remotes
  ])
  ++[inputs.system-manager.packages.${settings.system.arch}.system-manager]

  );
root= [

];
manager= system++[

  ];
system = with pkgs; [

      jre_minimal
      cryptsetup
      home-manager
      devbox

#       nix-doc
#       nix-init
      nix-diff
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
    ++ (with pkgs'.stable; [
#     floorp
    efibootmgr
    efitools
    efivar
    exfatprogs
    tmsu
    ])
    ++(with inputs; (map (pkg: (with pkg;(packages.${settings.system.arch}.default)))  ([
                fh
                agenix
                snowfall-flake
                nixos-conf-editor
#                 snow
#                 nix-software-center
#                 thorium-browser
                zen-browser
                NixVirt
                ]))
                ++(with winapps.packages.${settings.system.arch};[winapps winapps-launcher])
                ++[
                thorium-browser.defaultPackage.${settings.system.arch}
                ]);
plasma={
  system=((((with pkgs; [
    gnome-control-center
    plasma-hud
    systemdgenie
    gsignondPlugins.oauth

  ])++(with pkgs.kdePackages;[
    kio
    kio-gdrive
    kio-fuse
    kio-admin
    kio-extras
    kio-extras-kf5
    kio-zeroconf
    audiocd-kio
    kdesdk-kio
    plasma5support
    kcmutils
    sddm-kcm
    kcmutils
    flatpak-kcm
    kpipewire
    plymouth-kcm
    plasma-disks
    kdenlive
    plasmatube
    appstream-qt
    kmailtransport
    kaccounts-providers
    kaccounts-integration
    signond
    signon-kwallet-extension
#     kdevelop kdev-python
    discover
    ]))
#   ++ (with pkgs-stable;(with kdePackages;[ kdevelop kdev-python ]))
  ++ (with pkgs.libsForQt5;[

    qmltermwidget
    libkomparediff2
    ]))) ;
  user=(
    with pkgs;[
      libreoffice-qt
      krusader
      pcmanfm-qt
    # plasma-browser-integration
    ]++(with pkgs.kdePackages;[
      kate
      kcalc
      filelight
    ]
    )++(with pkgs.libsForQt5;[
      kdevelop
      kdev-python
    ]));
};
gnome={
  system=([

  ]);
  user=([

  ]);
hyprland={
  user=(with pkgs; [
    alacritty
    kitty
    feh
    killall
    polkit_gnome
    nwg-launchers
    papirus-icon-theme
    libva-utils
    libinput-gestures
    gsettings-desktop-schemas
    gnome.zenity
    wlr-randr
    wtype
    ydotool
    wl-clipboard
    hyprland-protocols
    hyprpicker
    hypridle
    hyprpaper
    fnott
    keepmenu
    pinentry-gnome3
    wev
    grim
    slurp
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    wlsunset
    pavucontrol
    pamixer
    tesseract4
    ]);
  system=[];
};
};
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
      (with pkgs'.stable;[
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
vscode = (with pkgs'.main;[
  vscode-fhs 
  vscode-extensions.kamadorueda.alejandra
  # vscode-extensions.brettm12345.nixfmt-vscode
  #vscodium-fhs
  ]);

games=(with pkgs'.main; [
    # Games
    pegasus-frontend
    libfaketime
    airshipper
    qjoypad
    superTux
    superTuxKart
    gamepad-tool
  ]) ++ (with pkgs'.stable; [
    pokefinder
  ]);
android-sdk-34 = (sdkPkgs: with sdkPkgs;[
                  build-tools-34-0-0
                  cmdline-tools-latest
                  emulator
                  platforms-android-34
                  sources-android-34
                ]);
mainDevEnv= [(pkgs'.unstable.python3.withPackages (p: with p;  [
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
      numpy
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
      
      pymysql
      imbalanced-learn
      statsmodels
      clickclick
      click
      openpyxl
      nltk
      spyder
      spyder-kernels
      pyls-spyder
      qdarkstyle
    ]))
    (pkgs'.stable.python3.withPackages (p: with p;  [
      sqlalchemy_1_4
    ]))
    ]
    ++ (with pkgs'.main; [
#       azure-cli
      kubectl
      libffi
      openssl
      gcc
      unzip
      grafana
      metabase
      # jupyter-all
      mysqltuner
      mysql-workbench
      # = { buildInputs = [ pkgs.qdarkstyle_3_02 ]; }; #( till errors are fixed : qdarkstyle & jedi versions not compatible/ packages not seen by spyder)
    ]) ++
    (with pkgs'.stable;[
      devenv
      ])
    # ++(with pkgs'.main.python311Packages;[
    
    #  ])
     ;
systemDevEnv=mainDevEnv;
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
  NixDevEnv= with pkgs-stable; mkShell{
    name = "pip-env"; buildInputs = mainDevEnv;
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
