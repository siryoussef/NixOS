{ settings, pkgs, ... }:

{
  # Doas instead of sudo
  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [{
    users = [ "${settings.user.username}" ];
    keepEnv = true;
    persist = true;
    noPass=false;
  }];

  environment.systemPackages = [
    (pkgs.writeScriptBin "sudo" ''exec doas "$@"'')
  ];
}
