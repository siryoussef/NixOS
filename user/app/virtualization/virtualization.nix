{ pkgs, pkgs-stable, pkgs-kdenlive, settings,inputs, config, ... }:

{
imports=[
  ./winapps.nix
];
  # Various packages related to virtualization, compatability and sandboxing
  home=let
    storage= import settings.paths.storage{inherit settings config;};
    pkgslists= import settings.paths.pkglists{inherit pkgs pkgs-stable pkgs-kdenlive;};
  in{
    packages= pkgslists.virtualisation.user;
    file=
#       storage.homeLinks.libvirt//
      {".config/libvirt/qemu.conf".text = '' nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ] '';};
      # Adapted from /var/lib/libvirt/qemu.conf
# Note that AAVMF and OVMF are for Aarch64 and x86 respectively

#     persistence=  storage.persistent.libvirt.user;
  };
    virtualisation.libvirt={
      swtpm.enable=true;

#       connections={
#         "qemu:///session"={
#           domains=[
#             {definition=inputs.NixVirt.lib.domain.writeXML (inputs.NixVirt.lib.domain.templates.windows{
#               name = "Windows";
#               uuid = "def734bb-e2ca-44ee-80f5-0ea0f2593aaa";
#               memory = { count = 8; unit = "GiB"; };
#               storage_vol = { pool = "DiscImgs"; volume = "Windows.qcow2"; };
#               install_vol = /Volume/Storage/Software/DiskImgs/Win11_23H2_EnglishInternational_x64v2.iso;
#               nvram_path = /Volume/Storage/Software/DiskImgs/win.nvram;
#               virtio_net = true;
#               virtio_drive = true;
#               install_virtio = true;
#               });
#             }
#           ];
#           networks =[
#             {definition=../../../system/virtualisation/libvirt/storage/DiscImgs.xml; active=true;}
#             {definition = inputs.NixVirt.lib.network.writeXML (inputs.NixVirt.lib.network.templates.bridge
#                 {
#                   uuid = "70b08691-28dc-4b47-90a1-45bbeac9ab5a";
#                   subnet_byte = 71;
#                 });
#               active = true;
#             }
#           ];
#           pools=[
#             {definition=../../../system/virtualisation/libvirt/storage/DiscImgs.xml; active=true;}
#           ];
#         };
#       };
    };
}
