{ pkgs, settings,... }:
{
  # Need some flatpaks
  services.flatpak={
    enable = true; update.onActivation = true;
    remotes = settings.pkglists.flatpakRepos;

    uninstallUnmanaged = true;
    packages = settings.pkglists.flatpaks;
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
