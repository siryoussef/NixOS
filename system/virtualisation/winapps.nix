{pkgs, inputs, settings, config, lib,...}:
{
environment.etc."winapps.conf".text = ''
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
fileSystems."/root/.config/winapps/winapps.conf"={device="/etc/winapps.conf"; fsType = "none"; options=["bind"];};
systemd =  {
  services.winapps = {
    enable=false;
    description = "Run WinApps Setup After Windows VM is Ready";
    name="winapps.service";
#     aliases=["winapps.service"];
    after = ["libvirtd.service" "graphical-session.target" "local-fs.target"];  # Ensure system is fully booted and libvirt is active
    wants = ["libvirtd.service" "graphical-session.target" "local-fs.target"];
    wantedBy = [ "default.target" "multi-user.target" ];  # Make sure this service runs during boot
    environment = {
        PATH= lib.mkDefault "${lib.makeBinPath config.environment.systemPackages++(with pkgs;[git curl])}";  # Set PATH to match the user's environment
        LIBVIRT_DEFAULT_URI="qemu:///system";  # Set libvirt to use the system session
      };
    script =
    ''
    #!/usr/bin/env bash
echo "Script started at $(date)" >> /home/${settings.user.username}/winapps-setup.log
echo "Current PATH: $PATH" >> /home/${settings.user.username}/winapps-setup.log
readonly HOME="/root"
readonly CONFIG_PATH="/etc/winapps.conf"
echo "Current HOME: $HOME" >> /home/${settings.user.username}/winapps-setup.log
echo "Current CONFIG_PATH: $CONFIG_PATH" >> /home/${settings.user.username}/winapps-setup.log
# Wait until the Windows VM is running
    while [[ "$(${pkgs.libvirt}/bin/virsh domstate RDPWindows)" != "running" ]];
    do ${pkgs.libvirt}/bin/virsh domstate RDPWindows  &>> /home/${settings.user.username}/winapps-setup.log && echo "Waiting for Windows VM to boot..."  >> /home/${settings.user.username}/winapps-setup.log
       sleep 3  # Wait for 3 seconds before checking again
    done

echo "windows-vm started at $(date)" >> /home/${settings.user.username}/winapps-setup.log
${inputs.winapps.packages.${settings.system.arch}.winapps}/bin/winapps-setup --system --uninstall &>> /home/${settings.user.username}/winapps-setup.log
${inputs.winapps.packages.${settings.system.arch}.winapps}/bin/winapps-setup --system --setupAllOfficiallySupportedApps &>> /home/${settings.user.username}/winapps-setup.log 2>&1
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;  # Keep the service marked as active after it completes
    };
  };
  timers.winapps = {
            wantedBy = ["timers.target"];
            timerConfig = {
#             OnCalendar = "daily";
            OnBootSec = "30s";
            Unit = "winapps.service";
            };
  };
};

}
