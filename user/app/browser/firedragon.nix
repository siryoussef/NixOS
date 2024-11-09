{ pkgs', ... }:

{
  # Module installing  as default browser
#   home.packages = [ pkgs.floorp ];

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs'.unstable.floorp}/bin/floorp";
  };
#   programs.firefox = {
#     enable = true;
# #     package = pkgs'.stable.floorp;
#     nativeMessagingHosts = /*{
#     packages =*/ with pkgs; [ uget-integrator browserpass];
#   # uget-integrator = true;
#   # browserpass = true; ##deprecated
# #     };
#   };
  xdg.mimeApps.defaultApplications = {
  "text/html" = "org.garudalinux.firedragon";
  "x-scheme-handler/http" = "org.garudalinux.firedragon";
  "x-scheme-handler/https" = "org.garudalinux.firedragon";
  "x-scheme-handler/about" = "org.garudalinux.firedragon";
  "x-scheme-handler/unknown" = "org.garudalinux.firedragon";
  };

}
