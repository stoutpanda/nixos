# nixos

NixOS config for two laptops. One flake, Home Manager as a NixOS module, one rebuild command.

| Host | Machine | Status |
|---|---|---|
| `voidreliquary` | Framework Laptop 13 Pro, Intel Core Ultra Series 3 | main laptop |
| `whitedwarf` | ASUS ROG Zephyrus G14 GA402X, Ryzen 7040 + RTX 4060 | defined; install after voidreliquary settles |

## Ground rules

1. One repo, one flake, one command: `sudo nixos-rebuild switch --flake ~/nixos#<host>` (alias `nrs`). It applies system and Home Manager together.
2. No secret tooling (no agenix, no sops, no private repo). Nothing secret goes in this repo. Apps ask for logins on first run.
3. No custom `options` or `my.*` layers. Modules are plain files a host imports or doesn't.
4. Stable channel (nixos-26.05). A package comes from unstable only through `overlays/unstable.nix`, one line each.
5. One theme, set once: Catppuccin Macchiato, Mauve. No theme switching.
6. Add things when you reach for them. One change, one commit. Roll back from the boot menu or with `sudo nixos-rebuild switch --rollback`.

## Layout

```
flake.nix             inputs + mkHost; one line per host
hosts/<name>/         default.nix picks desktop, users, modules; hardware.nix, disko.nix, hardware-configuration.nix
users/jason.nix       the NixOS account + home-manager.users.jason = ../home
modules/              system modules; never name a host, disk or IP
  base.nix            every host gets this (from flake.nix)
  laptop.nix  tailscale.nix  docker.nix  gaming.nix
  desktop/plasma.nix  a host imports exactly one desktop/<ui>.nix; it imports desktop/common.nix
home/                 Home Manager for jason: theme, shell, git, terminal, editor, apps
overlays/unstable.nix
archive/hyprland/     old Hyprland config, not imported
```

Add an app: put it in `home/apps.nix` (user apps) or the matching module (system services), rebuild, commit.

Add a host: copy `hosts/voidreliquary/`, replace `hardware.nix` and `disko.nix`, pick imports in `default.nix`, add `<name> = mkHost "<name>";` to `flake.nix`.

## Install

Every step runs on the laptop from the NixOS 26.05 ISO. **disko wipes the whole disk.**

```sh
# on the laptop, in the ISO shell (connect Wi-Fi first: nmtui)
sudo -i
ls -l /dev/disk/by-id | grep nvme | grep -v part
git clone https://github.com/stoutpanda/nixos.git /root/nixos
cd /root/nixos
vim hosts/<host>/disko.nix          # replace DISK-ID with the nvme-... name above
nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko/latest -- \
  --mode destroy,format,mount hosts/<host>/disko.nix   # asks for the LUKS passphrase
nixos-generate-config --no-filesystems --root /mnt --dir hosts/<host>
git add -A
git -c user.name=stoutpanda -c user.email=stoutpanda@protonmail.com commit -m "Add <host> hardware config"
nixos-install --flake .#<host> --no-root-passwd
cp -r /root/nixos /mnt/home/jason/nixos && chown -R 1000:100 /mnt/home/jason
reboot
```

## First login

1. Log in as `jason` with password `changeme`, then run `passwd`.
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
7. Thunderbird: add mail accounts in the app. Passwords go to KWallet.
8. Neovim with LazyVim (optional): `git clone https://github.com/LazyVim/starter ~/.config/nvim`
9. voidreliquary: enroll a fingerprint in System Settings > Users.

## Verify

```sh
# on the laptop
powerprofilesctl                # three profiles
fwupdmgr get-devices            # the laptop's firmware shows up
tailscale status
ssh-add -l                      # the Bitwarden key
```

Close the lid: it suspends. Steam launches a game. On whitedwarf: `supergfxctl -g`, `asusctl --help`, and a game with `nvidia-offload %command%`.

## Checking a change without a NixOS machine

```sh
docker run --rm -v "$PWD":/src -w /src nixos/nix sh -c \
  'git config --global --add safe.directory /src; nix --extra-experimental-features "nix-command flakes" \
   eval --raw .#nixosConfigurations.voidreliquary.config.system.build.toplevel.drvPath'
```
