{config, lib, pkgs, settings,...}:

{config = {
    nixpkgs.hostPlatform = settings.system.arch;
    system-manager.allowAnyDistro = true;

    environment = {
#       etc = {
#         "fstab".source=./fstab;
#         "fstab".text=let storage=import settings.paths.storage{inherit settings config;}; in storage.fstab;

#         "foo.conf".text = '' launch_the_rockets = true '';
#       };
      systemPackages = settings.pkglists.manager;
    };

  systemd={
    services = {
      userHome={
        enable = true;
        name="home-manager.service";
        aliases = ["home-manager"];
        description = "nix home-manager profile activation service for user";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        after = ["local-fs.target"];
        wantedBy = [ "system-manager.target" "multi-user.target" ];
        partOf = ["graphical-session.target"];
#         before = ["graphical-session.target"];
        script = ''
         /nix/var/nix/profiles/default/bin/home-manager switch --flake path:/mnt/NixOS/etc/nixos#youssef --show-trace --extra-experimental-features flakes --extra-experimental-features nix-command -b backup >>  /tmp/home-manager.log

         echo "We launched the rockets!" >> /tmp/home-manager.log 2>&1
        '';
      };
      rootHome={
        enable = true;
        name="root-manager.service";
        aliases = ["root-manager"];
        description = "nix home-manager profile activation service for root";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        after = ["local-fs.target"];
        wantedBy = [ "system-manager.target" "multi-user.target" ];
#         partOf = ["graphical-session.target"];
        before = ["graphical-session.target"];
        script = ''
          /nix/var/nix/profiles/default/bin/home-manager switch --flake path:/mnt/NixOS/etc/nixos#root --show-trace --extra-experimental-features flakes --extra-experimental >> /tmp/home-manager.log

          echo "We launched the rockets!" >> /tmp/root-manager.log 2>&1
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
