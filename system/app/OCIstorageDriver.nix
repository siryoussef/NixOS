{ lib, storageDriver ? "overlay2", ... }:

assert lib.asserts.assertOneOf "storageDriver" storageDriver [
#   null
  "aufs"
  "btrfs"
  "devicemapper"
  "overlay"
  "overlay2"
  "zfs"
];

{
  virtualisation={
    cri-o.storageDriver = storageDriver;
    docker.storageDriver = storageDriver;
  };
}
