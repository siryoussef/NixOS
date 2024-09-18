{ ... }:

{
  # Firewall
  networking = { firewall = {enable = true; allowedTCPPorts = [ 22000 21027 ]; allowedUDPPorts = [ 22000 21027 ]; }; };


}
