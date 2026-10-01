# Everything specific to the Framework 13 Pro board. A different machine replaces this file.
# Module name from FrameworkComputer/linux-docs (framework13/FW-13-Pro-NixOS-all-Intel-Core-Ultra-Series-3.md).
# The nixos-hardware module picks a kernel new enough for the board; do not override it here.
{ inputs, ... }:
{
  imports = [ inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series3 ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.enableRedistributableFirmware = true;

  # Fingerprint reader. Enroll once: fprintd-enroll, or System Settings > Users.
  services.fprintd.enable = true;

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };
}
