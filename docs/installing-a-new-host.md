# Installing a new host

This guide covers the whole path from an empty laptop to a working system: back up the old install, define the host in this repo, install from the NixOS ISO, then finish setup at first login. It also works for reinstalling an existing host (`voidreliquary` or `whitedwarf`): skip step 1 and pass that host's name.

**disko wipes the whole disk.** Do not start step 2 until the backup in step 0 has been checked.

## 0. Back up the current install

Backups are manual. Before installation, close applications and stop containers/VMs, then copy your home directory (including hidden files) to a separate backup destination. Save any needed Docker volumes, VM disks, or service data outside your home separately; use application/database exports where needed. Commit or back up any local changes to this repository too.

For an external Linux filesystem that supports permissions, ACLs, and extended attributes, run the following in Bash on the current installation. Change `backup_mount` to the actual mounted backup drive; the mount check prevents silently copying to an unmounted directory. Use an encrypted destination if the backup includes credentials or other private data.

```sh
set -e
backup_mount=/run/media/jason/Backup
mountpoint "$backup_mount"
backup_dir="$backup_mount/nixos-migration-$(hostname)-$(date +%F)"
mkdir -p "$backup_dir/home"
sudo rsync -aHAX --numeric-ids -- "$HOME/" "$backup_dir/home/"
sudo rsync -aHAXnc --numeric-ids --itemize-changes -- "$HOME/" "$backup_dir/home/"
```

The second rsync is a checksum-based dry run: investigate any differences or errors. Restore a few important files to a temporary directory and open them, including an application export if you depend on one. **Do not erase the laptop until this backup and test restore have succeeded.** Disconnect the backup drive before partitioning so it cannot be selected as the install target.

## 1. Define the host in the repo

Do this on a machine that already has the repo (or on the ISO before step 2). The new host needs a directory under `hosts/` and one line in `flake.nix`. Nothing else in the repo names a host.

```sh
new_host=<name>
cp -r hosts/voidreliquary "hosts/$new_host"
```

Then edit the copy:

| File | What to change |
|---|---|
| `hosts/<name>/default.nix` | Set `networking.hostName`. Pick imports: exactly one `modules/desktop/<ui>.nix`, plus whichever of `laptop.nix`, `tailscale.nix`, `docker.nix`, `gaming.nix` apply, plus `users/jason.nix`. Keep `system.stateVersion` at the release you install with. |
| `hosts/<name>/hardware.nix` | Everything specific to the machine. Import the matching module from [nixos-hardware](https://github.com/NixOS/nixos-hardware) (see its `flake.nix` for names), keep systemd-boot and the monthly Btrfs scrub, and add any vendor services (fingerprint reader, `asusd`, and so on). Drop anything from the copied host that does not apply. |
| `hosts/<name>/disko.nix` | Disk layout: ESP + LUKS with Btrfs subvolumes for `/`, `/nix`, `/home`, `/var/log`, `/.snapshots`. Set `device` to `/dev/disk/by-id/DISK-ID`; step 2 fills in the real ID. Adjust partition sizes to the disk. voidreliquary's copy also has a randomly encrypted swap partition. Keep it if you want disk swap on top of zram, or delete that partition to use zram only, as whitedwarf does. |
| `hosts/<name>/hardware-configuration.nix` | Leave the copy for now so the flake evaluates. Step 2 replaces it with the real one. |
| `flake.nix` | Add `<name> = mkHost "<name>";` under `nixosConfigurations`. |

Also add the new host to the `for host in ...` loops in [maintenance.md](maintenance.md) and the host table in the [README](../README.md).

Check that it evaluates (see [maintenance.md](maintenance.md) for doing this without NixOS), then commit and push so the ISO can clone it:

```sh
nix eval --no-write-lock-file --raw ".#nixosConfigurations.$new_host.config.system.build.toplevel.drvPath"
git add "hosts/$new_host" flake.nix
git commit -m "Add $new_host"
git push
```

## 2. Install from the ISO

Every step runs on the laptop from the NixOS 26.05 ISO, in a Bash shell. Commit and push the configuration you intend to install so the clone below includes it.

First identify the disk, capture the real hardware configuration, and build the system before changing any partitions. Set `install_host` to the laptop you are installing. The ISO's Nix store uses RAM; this desktop build needs enough space for its full closure. If it will not fit, use a persistent Nix store on a separate drive that will not be erased.

```sh
# on the laptop, in the ISO shell (connect Wi-Fi first: nmtui)
sudo -i
set -e
export NIX_CONFIG='experimental-features = nix-command flakes'
install_host=voidreliquary         # or whitedwarf, or the host from step 1
git clone https://github.com/stoutpanda/nixos.git /root/nixos
cd /root/nixos
lsblk -o NAME,SIZE,MODEL,SERIAL,MOUNTPOINTS
ls -l /dev/disk/by-id | grep nvme | grep -v part
vim "hosts/$install_host/disko.nix" # replace DISK-ID with the matching nvme-... name
nixos-generate-config --no-filesystems --show-hardware-config \
  > "hosts/$install_host/hardware-configuration.nix"
git add "hosts/$install_host/disko.nix" "hosts/$install_host/hardware-configuration.nix"
nix build --no-write-lock-file \
  ".#nixosConfigurations.$install_host.config.system.build.toplevel" \
  --out-link /root/nixos-preflight
nix run --no-write-lock-file .#disko -- --help
```

Continue in the same shell only after the build succeeds and the selected disk and backup have been checked. The local disko app uses the revision in `flake.lock`. Install the exact system built above, then set your login password interactively before rebooting; the repo contains no initial password.

```sh
nix run --no-write-lock-file .#disko -- \
  --mode destroy,format,mount --flake ".#$install_host" # asks for the LUKS passphrase
nixos-install --system "$(readlink -f /root/nixos-preflight)" --no-root-passwd
nixos-enter --root /mnt -c 'passwd jason'
git -c user.name=stoutpanda -c user.email=stoutpanda@protonmail.com \
  commit -m "Add $install_host hardware config"
mkdir -p /mnt/home/jason/nixos
cp -a /root/nixos/. /mnt/home/jason/nixos/
nixos-enter --root /mnt -c 'chown -R jason:users /home/jason/nixos'
reboot
```

## 3. First login

1. Log in as `jason` with the password you set during installation.
2. Open Bitwarden, sign in, turn on Settings > SSH agent. Check: `ssh-add -l`.
3. `cd ~/nixos && git remote set-url origin git@github.com:stoutpanda/nixos.git && git push`
4. `sudo tailscale up --accept-routes`
5. `gh auth login`, `glab auth login`, `rbw config set email <you>` as needed.
6. Plasma theme, once:
   ```sh
   plasma-apply-lookandfeel -a Catppuccin-Macchiato-Mauve
   plasma-apply-cursortheme catppuccin-macchiato-mauve-cursors
   kwriteconfig6 --file kdeglobals --group Icons --key Theme Papirus-Dark
   ```
7. Thunderbird: add mail accounts in the `default` profile, which also receives the Catppuccin theme. Restore an existing mail profile first if you are migrating one.
8. Neovim with LazyVim (optional): `git clone https://github.com/LazyVim/starter ~/.config/nvim`. Home Manager installs Neovim and its build tools; LazyVim owns its configuration, plugins, and theme. If restoring an existing Neovim configuration, use that instead of cloning the starter. Set Catppuccin Macchiato in LazyVim's configuration.
9. voidreliquary: enroll a fingerprint in System Settings > Users.

## 4. Restore data

Reconnect the backup and restore documents, projects, and application data selectively while the affected apps are closed. For example, set `backup_dir` to the verified backup directory, then run this as `jason`:

```sh
rsync -aH --no-owner --no-group -- "$backup_dir/home/Documents/" "$HOME/Documents/"
```

Keep Home Manager's generated configuration files in place instead of restoring all of `.config` over them. Restore your existing Neovim configuration before following the optional LazyVim clone step. Migrate Thunderbird mail/account data into the configured `default` profile, preserving the generated `profiles.ini` and `user.js` files. Keep the original backup until the restored files and applications have been checked, and repeat the backup periodically and before major upgrades.

NixOS generation rollback restores system configuration and packages; it does not restore your documents or application databases. `/.snapshots` is reserved for possible future use: no automatic Btrfs snapshots or backup service are configured. Monthly Btrfs scrubs check filesystem integrity and do not replace a backup.

## 5. Verify

```sh
# on the laptop
powerprofilesctl                # three profiles
fwupdmgr get-devices            # the laptop's firmware shows up
tailscale status
ssh-add -l                      # the Bitwarden key
```

Check audio, microphone, Wi-Fi, Bluetooth, and an external display. Test lid-close suspend and resume on both battery and AC; docked lid-close is configured to do nothing. Check the actual Plasma behavior as well, since its power settings can take over lid handling. Steam should launch a game.

Both laptops suspend only; hibernation and suspend-then-hibernate are not configured. Swap differs per host:

- **voidreliquary:** zram (from `modules/laptop.nix`) plus a 32G swap partition in `disko.nix`. The partition uses `randomEncryption`, so it gets a fresh key on every boot and cannot be a hibernation target. It is set to priority 1, below zram's default of 5, so the kernel fills zram first and uses the disk partition only as overflow.
- **whitedwarf:** zram only.

Check with `swapon --show`: it should list `/dev/zram0`, and on voidreliquary also the encrypted partition (`/dev/mapper/...`) with the priorities above.

On whitedwarf: check `supergfxctl -g`, `asusctl --help`, and a game with `nvidia-offload %command%`. Boot the `power-saving` specialisation separately, then test suspend/resume and the display connections you use there too. This host intentionally uses `linuxPackages_latest` from the stable input; repeat the graphics, peripheral, and suspend checks after kernel updates.

Check `systemctl --failed` and `systemctl status home-manager-jason.service`. After the first successful rebuild, boot the previous generation once to confirm the recovery path. The boot menu keeps at most five generations; weekly garbage collection removes eligible generations older than 14 days.
