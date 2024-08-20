{ pkgs,... }:

let
flatpakslist= (map(pkg:{appId = pkg; origin = "flathub";})[
      "io.github._0xzer0x.qurancompanion"
      "io.github.flattool.Warehouse"
      "org.spyder_ide.spyder"
      "org.garudalinux.firedragon"
      "org.jupyter.JupyterLab"
      "page.codeberg.JakobDev.jdFlatpakSnapshot"
      "org.sqlitebrowser.sqlitebrowser"
      "com.github.tchx84.Flatseal"

      ]) ++ (map(pkg:{appId = pkg; origin = "flathub-beta";})[
      "org.signal.Signal"

      ]) ++[
      { appId = "com.brave.Browser"; origin = "flathub";  }
#       { appId = "org.signal.Signal"; origin = "flathub-beta";}
  #     "com.obsproject.Studio"
  #     "im.riot.Riot"
    ];
    in {
  # Need some flatpaks
  services.flatpak={
    enable = true; update.onActivation = true;
    remotes = [
      {name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";}
      {name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo";}
      {name = "gnome-nightly"; location = "https://nightly.gnome.org/gnome-nightly.flatpakrepo";}
      ];

    uninstallUnmanaged = true;
    packages = flatpakslist;
    };
  xdg.portal.enable = true;

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
    };
}
