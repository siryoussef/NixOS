{pkgs,...}:
{
/*
systemd.user=  {
  services.winappsSetup = {
    description = "Run WinApps Setup After Windows VM is Ready";
    after = [ "libvirtd.service" ];  # Ensure system is fully booted and libvirt is active
    wants = [  "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];  # Make sure this service runs during boot
    script =
    ''
    #!/bin/sh
echo "Script started at $(date)" >> /tmp/winapps-setup.log
# Wait until the Windows VM is running
    while [ "$(sudo virsh domstate RDPWindows)" != "running" ];
    do  echo "Waiting for Windows VM to boot..." >> /tmp/winapps-setup.log
      sleep 3  # Wait for 3 seconds before checking again
    done
# echo "Current PATH: $PATH" >> /tmp/winapps-setup.log
echo "windows-vm started at $(date)" >> /tmp/winapps-setup.log
${inputs.winapps.packages.${settings.system.arch}.winapps}/bin/winapps-setup --user --setupAllOfficiallySupportedApps >> /tmp/winapps-setup.log 2>&1
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;  # Keep the service marked as active after it completes
    };
  };
  timers.winappsSetup = {
            wantedBy = ["timers.target"];
            timerConfig = {
#             OnCalendar = "daily";
            OnBootSec = "30s";
            Unit = "winappsSetup.service";
            };
    };
};
*/
}
