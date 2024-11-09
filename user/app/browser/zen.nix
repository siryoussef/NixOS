{ pkgs',... }:

{
  # Module installing  as default browser
  home.packages = [ pkgs'.main.zen ];

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.zen}/bin/zen";
  };
  programs.firefox = {
    enable = true;
    package = pkgs'.stable.zen;
    nativeMessagingHosts = /*{
    packages =*/ with pkgs; [ uget-integrator browserpass];
  # uget-integrator = true;
  # browserpass = true; ##deprecated
#     };
  };
  xdg.mimeApps.defaultApplications = {
  "text/html" = "zen.desktop";
  "x-scheme-handler/http" = "zen.desktop";
  "x-scheme-handler/https" = "zen.desktop";
  "x-scheme-handler/about" = "zen.desktop";
  "x-scheme-handler/unknown" = "zen.desktop";
  };

}
