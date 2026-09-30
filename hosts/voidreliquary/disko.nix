# One NVMe: ESP + LUKS, btrfs inside with subvolumes for /, /nix, /home, /var/log, /.snapshots.
# disko asks for the LUKS passphrase when it formats; the same passphrase unlocks at boot.
# Replace DISK-ID from the installer: ls -l /dev/disk/by-id | grep nvme | grep -v part
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
    device = "/dev/disk/by-id/nvme-SLEG-900-001TC_2Q262L1619D1";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          size = "2G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
	encryptedSwap = {
              size = "32G";
              content = {
                type = "swap";
                randomEncryption = true;
                priority = 100; # prefer to encrypt as long as we have space for it
              };
            };
        luks = {
          size = "800G";
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
