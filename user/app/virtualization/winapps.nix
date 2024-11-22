{settings, inputs, lib, pkgs, ...}:
let
sudo=
"/run/wrappers/bin/doas";
#"${pkgs.doas}/bin/doas";
winapps-setup=
"${inputs.winapps.packages.${settings.system.arch}.winapps}/bin/winapps-setup";
log="/home/${settings.user.username}/winapps-setup.log";

in
rec{
  home.file={
    ".local/share/mime/packages/pbix-mime.xml".text =/*xml*/ ''
      <?xml version="1.0" encoding="UTF-8"?>
      <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
          <mime-type type="application/vnd.ms-powerbi.pbix">
              <comment>Power BI Desktop file</comment>
              <glob pattern="*.pbix"/>
          </mime-type>
      </mime-info>
    '';
    "/winapps.sh"={ executable=true; text = /*bash*/''
    #!/usr/bin/env bash
echo "Script started at $(date)" >> ${log}
echo "Current PATH: $PATH" >> ${log}
# Wait until the Windows VM is running
    while [[ "$(${sudo} ${pkgs.libvirt}/bin/virsh domstate RDPWindows)" != "running" ]];
    do ${sudo} virsh domstate RDPWindows  &>> ${log} && echo "Waiting for Windows VM to boot..."  >> ${log}
       sleep 3  # Wait for 3 seconds before checking again
    done
echo "windows-vm started at $(date)" >> ${log}
${winapps-setup} --user --uninstall >> ${log}
${winapps-setup} --user --setupAllOfficiallySupportedApps >> ${log} 2>&1
ln -s $(which winapps) /home/${settings.user.username}/.local/bin
'';};
    ".config/winapps/winapps.conf".text =/*toml*/ ''


#   RDP_IP="192.168.122.11"  # Assuming the VM uses libvirt default network
#   RDP_SCALE=100
#   AUTO_CONNECT=true

##################################
#   WINAPPS CONFIGURATION FILE   #
##################################

# INSTRUCTIONS
# - Leading and trailing whitespace are ignored.
# - Empty lines are ignored.
# - Lines starting with '#' are ignored.
# - All characters following a '#' are ignored.

# [WINDOWS USERNAME]
RDP_USER=${settings.user.name}

# [WINDOWS PASSWORD]
RDP_PASS=" "

# [WINDOWS DOMAIN]
# DEFAULT VALUE:  (BLANK)
RDP_DOMAIN=""

# [WINDOWS IPV4 ADDRESS]
# NOTES:
# - If using 'libvirt', 'RDP_IP' will be determined by WinApps at runtime if left unspecified.
# DEFAULT VALUE:
# - 'docker': '127.0.0.1'
# - 'podman': '127.0.0.1'
# - 'libvirt': "" (BLANK)
RDP_IP=""

# [WINAPPS BACKEND]
# DEFAULT VALUE: 'docker'
# VALID VALUES:
# - 'docker'
# - 'podman'
# - 'libvirt'
# - 'manual'
WAFLAVOR="libvirt"

# [DISPLAY SCALING FACTOR]
# NOTES:
# - If an unsupported value is specified, a warning will be displayed.
# - If an unsupported value is specified, WinApps will use the closest supported value.
# DEFAULT VALUE: '100'
# VALID VALUES:
# - '100'
# - '140'
# - '180'
RDP_SCALE="100"

# [ADDITIONAL FREERDP FLAGS & ARGUMENTS]
# DEFAULT VALUE: "" (BLANK)
# VALID VALUES: See https://github.com/awakecoding/FreeRDP-Manuals/blob/master/User/FreeRDP-User-Manual.markdown
RDP_FLAGS=""

# [MULTIPLE MONITORS]
# NOTES:
# - If enabled, a FreeRDP bug *might* produce a black screen.
# DEFAULT VALUE: 'false'
# VALID VALUES:
# - 'true'
# - 'false'
MULTIMON="false"

# [DEBUG WINAPPS]
# NOTES:
# - Creates and appends to ~/.local/share/winapps/winapps.log when running WinApps.
# DEFAULT VALUE: 'true'
# VALID VALUES:
# - 'true'
# - 'false'
DEBUG="true"

# [AUTOMATICALLY PAUSE WINDOWS]
# NOTES:
# - This is currently INCOMPATIBLE with 'docker' and 'manual'.
# - See https://github.com/dockur/windows/issues/674
# DEFAULT VALUE: 'off'
# VALID VALUES:
# - 'on'
# - 'off'
AUTOPAUSE="off"

# [AUTOMATICALLY PAUSE WINDOWS TIMEOUT]
# NOTES:
# - This setting determines the duration of inactivity to tolerate before Windows is automatically paused.
# - This setting is ignored if 'AUTOPAUSE' is set to 'off'.
# - The value must be specified in seconds (to the nearest 10 seconds e.g., '30', '40', '50', etc.).
# - For RemoteApp RDP sessions, there is a mandatory 20-second delay, so the minimum value that can be specified here is '20'.
# - Source: https://techcommunity.microsoft.com/t5/security-compliance-and-identity/terminal-services-remoteapp-8482-session-termination-logic/ba-p/246566
# DEFAULT VALUE: '300'
# VALID VALUES: >=20
AUTOPAUSE_TIME="300"

# [FREERDP COMMAND]
# NOTES:
# - WinApps will attempt to automatically detect the correct command to use for your system.
# DEFAULT VALUE: "" (BLANK)
# VALID VALUES: The command required to run FreeRDPv3 on your system (e.g., 'xfreerdp', 'xfreerdp3', etc.).
FREERDP_COMMAND=""

  '';

#  ".local/bin/winapps"= /*lib.hm.dag.entryAfter "winlink" ["home-activation-runWinapps-setup"]*/ {source="${inputs.winapps.packages.${settings.system.arch}.winapps}/bin/winapps";};
};
# home.activation.runWinapps-setup = /*lib.hm.dag.entryAfter ["writeBoundary" "graphical-session.target" "libvirt.service" "multi-user.target"]*/ lib.hm.dag.entryBetween /*["home-file-.local-bin-winapps"]*/ "winsetup" ["winlink"] ["writeBoundary"] /*bash*/''
# #!/bin/sh
# echo "Script started at $(date)" >> /tmp/winapps-setup.log
# # Wait until the Windows VM is running
#     while [ "$(${sudo} virsh domstate RDPWindows)" != "running" ];
#     do  echo "Waiting for Windows VM to boot..." >> /tmp/winapps-setup.log
#       sleep 3  # Wait for 10 seconds before checking again
#     done
# # echo "Current PATH: $PATH" >> /tmp/winapps-setup.log
# echo "windows-vm started at $(date)" >> /tmp/winapps-setup.log
# ${winapps-setup} --user --setupAllOfficiallySupportedApps >> /tmp/winapps-setup.log 2>&1
# '' ;
#buggy setup
# systemd.user= /*lib.hm.dag.entryBefore ["home-file-.local-bin-winapps"]*/ {enable =true; services.winappsSetup = {
#     Unit={
#       Description = "Run WinApps Setup After Windows VM is Ready";
#       after = [ /*"multi-user.target"*/ "libvirtd.service" ];  # Ensure system is fully booted and libvirt is active
#       wants = [ /*"multi-user.target"*/ "libvirtd.service" ];
#       wantedBy = [ "multi-user.target" ];  # Make sure this service runs during boot
#     };
#     script = " ${winapps-setup} --user --setupAllOfficiallySupportedApps >> /tmp/winapps-setup.log 2>&1 ";
# #     ''
# #     #!/bin/sh
# # echo "Script started at $(date)" >> /tmp/winapps-setup.log
# # # Wait until the Windows VM is running
# #     while [ "$(${sudo} virsh domstate RDPWindows)" != "running" ];
# #     do  echo "Waiting for Windows VM to boot..." >> /tmp/winapps-setup.log
# #       sleep 3  # Wait for 10 seconds before checking again
# #     done
# # # echo "Current PATH: $PATH" >> /tmp/winapps-setup.log
# # echo "windows-vm started at $(date)" >> /tmp/winapps-setup.log
# # ${winapps-setup} --user --setupAllOfficiallySupportedApps >> /tmp/winapps-setup.log 2>&1
# #     '';
#     serviceConfig = {
#       Type = "oneshot";  # Run the script once and then exit
# #       ExecStartPre = ''  # Wait for the Windows VM to be in running state
# # echo "Script started at $(date)" >> /tmp/winapps-setup.log
# # # Wait until the Windows VM is running
# #     while [ "$(${sudo} virsh domstate RDPWindows)" != "running" ];
# #     do  echo "Waiting for Windows VM to boot..." >> /tmp/winapps-setup.log
# #       sleep 3  # Wait for 3 seconds before checking again
# #     done
# #     echo "Current PATH: $PATH" >> /tmp/winapps-setup.log
# #     echo "windows-vm started at $(date)" >> /tmp/winapps-setup.log
# #       '';
# #       ExecStart = "${winapps-setup} --user --setupAllOfficiallySupportedApps";
# #       ExecStartPost = ''  # Log success
# #         echo "WinApps setup complete at $(date)" >> /var/log/winapps-setup.log;
# #       '';
#       RemainAfterExit = true;  # Keep the service marked as active after it completes
#     };
#   };
#   timers.winappsSetup = {
#             wantedBy = ["timers.target"];
#             timerConfig = {
# #             OnCalendar = "daily";
#             OnBootSec = "30s";
#             Unit = "winappsSetup.service";
#             };
#     };
# };
xdg.mimeApps.associations.added = {
      "application/vnd.ms-powerbi.pbix" = "winapps-powerbi.desktop";
    };
}
