{ pkgs,... }:

{
  # Need some flatpaks
  services.flatpak={
    enable = true; update.onActivation = true;
    remotes = [
      {name = "flathub-beta"; location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";}
      {name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo";}
      {name = "gnome-nightly"; location = "https://nightly.gnome.org/gnome-nightly.flatpakrepo";}
      ];

    uninstallUnmanaged = false;
    packages = [
      { appId = "com.brave.Browser"; origin = "flathub";  }
  #     "com.obsproject.Studio"
  #     "im.riot.Riot"
    ];
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
