# One NVMe: ESP + LUKS, btrfs inside with subvolumes for /, /nix, /home, /var/log, /.snapshots.
# disko asks for the LUKS passphrase when it formats; the same passphrase unlocks at boot.
# Replace DISK-ID from the installer: ls -l /dev/disk/by-id | grep nvme | grep -v part
let
  opts = [
    "compress=zstd"
    "noatime"
  ];
in
{
  disko.devices.disk.os = {
    type = "disk";
    device = "/dev/disk/by-id/DISK-ID";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "cryptroot";
            settings.allowDiscards = true;
            content = {
              type = "btrfs";
              extraArgs = [
                "-f"
                "-L"
                "os"
              ];
              subvolumes = {
                "@root" = {
                  mountpoint = "/";
                  mountOptions = opts;
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = opts;
                };
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = opts;
                };
                "@log" = {
                  mountpoint = "/var/log";
                  mountOptions = opts;
                };
                "@snapshots" = {
                  mountpoint = "/.snapshots";
                  mountOptions = opts;
                };
              };
            };
          };
        };
      };
    };
  };
}
