{config, lib, pkgs, settings,...}:

{config = {
    nixpkgs.hostPlatform = settings.system.arch;
    system-manager.allowAnyDistro = true;

    environment = {
      etc = {
#         "fstab".source=./fstab;
        "fstab".text=let storage=import settings.paths.storage{inherit settings config;}; in storage.fstab;

#         "foo.conf".text = '' launch_the_rockets = true '';
      };
      systemPackages = settings.pkglists.manager;
    };

  systemd={
    services = {
      home-manager={
        enable = true;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        after = ["local-fs.target"];
        wantedBy = [ "system-manager.target" "multi-user.target" ];
        script = ''
          /nix/var/nix/profiles/default/bin/home-manager switch --flake path:/mnt/NixOS/etc/nixos#youssef --show-trace --extra-experimental-features flakes --extra-experimental-features nix-command -b backup
          echo "We launched the rockets!"
        '';
      };
#       foo = {
#         enable = true;
#         serviceConfig = {
#           Type = "oneshot";
#           RemainAfterExit = true;
#         };
#         wantedBy = [ "system-manager.target" ];
#         script = ''
#           ${lib.getBin pkgs.hello}/bin/hello
#           echo "We launched the rockets!"
#         '';
#       };
    };
  };
};
}
