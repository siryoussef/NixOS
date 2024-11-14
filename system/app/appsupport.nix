{ pkgs', settings, config,... }:
rec{
  # Need some flatpaks
  services={
    guix ={
      enable=true;
      package= pkgs'.unstable.guix;
      storeDir= "/nix/gnu/store";
      stateDir= "/nix/gnu/var";
      group="guixbuild";
      nrBuildUsers=11;
      extraArgs=[
        "--max-jobs=4"
#         "--debug"
        ];
      gc={
        enable=true;
        extraArgs=[
#   "--delete-generations=1m"
#   "--free-space=10G"
  "--optimize"
        ];
        dates="weekly";
      };
      /*substituters={
        urls=[
          "https://ci.guix.gnu.org"
          "https://bordeaux.guix.gnu.org"
          "https://berlin.guix.gnu.org"
        ];
#         authorizedKeys= [
#           (builtins.fetchurl {url = "https://guix.example.com/signing-key.pub";})
#           (builtins.fetchurl {url = "https://guix.example.org/static/signing-key.pub";})
#         ];
      };*/
      publish={
        enable=false;
        port=8181;
        user="guix-publish";
        generateKeyPair=true; ##Whether to generate signing keys in /etc/guix which are required to initialize a substitute server. Otherwise, --public-key=$FILE and --private-key=$FILE can be passed in services.guix.publish.extraArgs.
      };
    };
    flatpak={
      enable = true; update.onActivation = true;
      remotes = settings.pkglists.flatpakRepos;

      uninstallUnmanaged = true;
      packages = settings.pkglists.flatpaksForNixFlatpak; #settings.pkglists.flatpaksForDeclarativeFlatpak;
      };
  };
  users= {
    users= (if services.flatpak.enable==true then{flatpak.uid=998;} else {})//(if services.guix.enable==true then{
      guixbuilder0.uid =1001;
      guixbuilder1.uid =1002;
      guixbuilder2.uid =1003;
      guixbuilder3.uid =1004;
      guixbuilder4.uid =1005;
      guixbuilder5.uid =1006;
      guixbuilder6.uid =1007;
      guixbuilder7.uid =1008;
      guixbuilder8.uid =1009;
      guixbuilder9.uid =1010;
      guixbuilder10.uid =1011;
    } else {});
    groups=(if services.flatpak.enable==true then{flatpak.gid=997;} else {})//(if services.guix.enable==true then{guixbuild.gid=1001;} else {});
};
  xdg.portal.enable = true;

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs'.stable.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
    };
}
