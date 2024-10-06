{ pkgs, ... }:

{
  # Enable printing
  services.printing={enable = true;
    drivers= with pkgs;[hplipWithPlugin gutenprint splix cups-filters];
    webInterface=true;
    browsing=true;
  };
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;
  environment.systemPackages = with pkgs;[ cups-filters hplipWithPlugin simple-scan system-config-printer];
}
