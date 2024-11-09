{ pkgs', ... }:

{
  # Module installing  as default browser
  home.packages = [ pkgs'.unstable.floorp ];

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs'.unstable.floorp}/bin/floorp";
  };
  programs.firefox = {
    enable = true;
    package = pkgs'.stable.floorp;
    nativeMessagingHosts = /*{
    packages =*/ with pkgs'.main; [ uget-integrator browserpass];
  # uget-integrator = true;
  # browserpass = true; ##deprecated
#     };
  };
  xdg.mimeApps.defaultApplications = {
  "text/html" = "floorp.desktop";
  "x-scheme-handler/http" = "floorp.desktop";
  "x-scheme-handler/https" = "floorp.desktop";
  "x-scheme-handler/about" = "floorp.desktop";
  "x-scheme-handler/unknown" = "floorp.desktop";
  };

}
