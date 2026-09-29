# PLACEHOLDER so the flake evaluates before install. Replace it on the installer with:
#   nixos-generate-config --no-filesystems --root /mnt --dir hosts/whitedwarf
# Filesystems come from disko.nix, not from this file.
{ lib, ... }:
{
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-amd" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
