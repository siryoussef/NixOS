{...}:
{
imports= (map (x:(./security)+(x))[
  /doas.nix
  /gpg.nix
  /blocklist.nix
  /firewall.nix
  /firejail.nix
  /openvpn.nix
  /automount.nix
]);
security = {
  rtkit.enable = true;
  #ipa.chromiumSupport = true;
  #chromiumSuidSandbox.enable = true;
  tpm2.enable = false;
  apparmor.enable = false;
  allowSimultaneousMultithreading = true;
  polkit={enable = true; debug=true;
#     extraConfig= ''
#     /* Log authorization checks. */
#     polkit.addRule(function(action, subject) {
#       // Make sure to set { security.polkit.debug = true; } in configuration.nix
#       polkit.log("user " +  subject.user + " is attempting action " + action.id + " from PID " + subject.pid);
#     });
#
#     /* Allow any local user to do anything (dangerous!). */
#     polkit.addRule(function(action, subject) {
#       if (subject.local) return "yes";
#     });
#     '';
  };
};
}
