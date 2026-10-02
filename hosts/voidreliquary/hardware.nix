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

  # Removable Steam library (microSD).
  # nofail + automount: boot never waits for it; it mounts on first access when present,
  # and access gives up after a few seconds when absent, so Steam just shows the library offline.
  fileSystems = builtins.mapAttrs (_: uuid: {
    device = "/dev/disk/by-uuid/${uuid}";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "nofail"
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=10min"
      "x-systemd.device-timeout=3s"
      "x-systemd.mount-timeout=10s"
    ];
  }) {
    "/mnt/msd_games" = "e35e87c1-9d37-4d82-b745-b0e018cd50b3";
  };
}
