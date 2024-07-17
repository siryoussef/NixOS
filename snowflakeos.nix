{ pkgs, inputs, systemSettings, ... }:
{
#   environment.systemPackages = with inputs; [
# #   nix-software-center.packages.${systemSettings.system}.nix-software-center
#     nixos-conf-editor.packages.${systemSettings.system}.default
# #   snow.packages.${systemSettings.system}.snow
  environment.systemPackages = (map (pkg : pkg.packages.${systemSettings.system}.default) (with inputs; [
                fh
                snowfall-flake
                nixos-conf-editor
#                 snow
                nix-sofware-center
                ])) ;
  ];

  programs.nix-data = {
    systemconfig =  (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix");
    flake = "/etc/nixos/flake.nix";
    flakearg = "Snowyfrank";
  };

#   snowflakeos.gnome.enable = false;
#   snowflakeos.osInfo.enable = true;

  }
