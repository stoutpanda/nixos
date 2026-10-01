# nixos

NixOS config for two laptops. One flake, Home Manager as a NixOS module, one rebuild command.

| Host | Machine | Status |
|---|---|---|
| `voidreliquary` | Framework Laptop 13 Pro, Intel Core Ultra Series 3 | main laptop |
| `whitedwarf` | ASUS ROG Zephyrus G14 GA402X, Ryzen 7040 + RTX 4060 | defined; install after voidreliquary settles |

## Documentation

- [Installing a new host](docs/installing-a-new-host.md): backup, adding a host to the flake, installing from the ISO, first login, restore, verification.
- [Maintenance](docs/maintenance.md): evaluating and building hosts, updating inputs, checking a change without NixOS, rolling back.
- [Archived Hyprland config](archive/hyprland/README.md): the old Hyprland setup, kept for reference and not imported.

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
docs/                 install and maintenance guides
archive/hyprland/     old Hyprland config, not imported
```

Add an app: put it in `home/apps.nix` (user apps) or the matching module (system services), rebuild, commit.

Add a host: see [Installing a new host](docs/installing-a-new-host.md#1-define-the-host-in-the-repo).

## History

This repo replaces several earlier attempts. They are kept on GitHub for reference; nothing here imports them.

| Repo | What it was |
|---|---|
| [stoutpanda/nix-hydenix](https://github.com/stoutpanda/nix-hydenix) (archived) | A first pass at NixOS by way of [Hydenix](https://github.com/richen604/hydenix), to learn how NixOS and a HyDE/hyprdots Hyprland setup fit together. |
| [stoutpanda/nix-conf](https://github.com/stoutpanda/nix-conf) (archived) | The first hand-written NixOS config. Set aside to rebuild with Home Manager first. |
| [stoutpanda/home-manager](https://github.com/stoutpanda/home-manager) | Standalone Home Manager flake: `my.*` enable options, Catppuccin, LazyVim, Ghostty, and agenix secrets pulled from a separate private repo. |
| [stoutpanda/nix-configs](https://github.com/stoutpanda/nix-configs) | NixOS flake for whitedwarf on nixos-unstable: Hyprland, NVIDIA PRIME offload, the CachyOS kernel via Chaotic-Nyx, and Lix. It took Home Manager from the repo above. |

What changed in this repo, and why: the two-repo split and the private secrets repo became one flake with Home Manager as a NixOS module; agenix was dropped in favor of keeping nothing secret in git; `my.*` option layers became plain imports; unstable, Chaotic-Nyx, and Lix became the stable channel with a one-line-per-package unstable overlay; Hyprland became Plasma (the Hyprland config lives in `archive/hyprland/`); and hand-partitioning became disko.

## Inspirations

Carried over from the earlier repos:

- [vimjoyer's flake-starter-config](https://github.com/vimjoyer/flake-starter-config): modular structure.
- [Mitchell Hashimoto's nixos-config](https://github.com/mitchellh/nixos-config): using flakes to pull in specific software projects, and [thoughtful Home Manager program configs](https://github.com/mitchellh/nixos-config/blob/main/users/mitchellh/home-manager.nix).
- [fzakaria/nix-home](https://github.com/fzakaria/nix-home): the "Secrets for Dummies" guide to secrets in Nix.
- [Hydenix](https://github.com/richen604/hydenix): helped me wrap my head around Hyprland on NixOS.
- [Omarchy](https://github.com/basecamp/omarchy) and [DHH](https://github.com/dhh): for making me aware of [Hyprland](https://github.com/hyprwm/Hyprland).
- [Surma's "Nix Explained from the Ground Up"](https://www.youtube.com/watch?v=5D3nUU1OVx8) video.

## Attributions

This config is built on:

- [NixOS / nixpkgs](https://github.com/NixOS/nixpkgs)
- [Home Manager](https://github.com/nix-community/home-manager)
- [disko](https://github.com/nix-community/disko): declarative partitioning, LUKS, and Btrfs subvolumes.
- [nixos-hardware](https://github.com/NixOS/nixos-hardware): the Framework and Zephyrus hardware modules.
- [Framework linux-docs](https://github.com/FrameworkComputer/linux-docs): the NixOS guide for the Framework 13 Pro that names the voidreliquary hardware module.
- [asus-linux](https://asus-linux.org/): `asusctl`, `supergfxctl`, and ROG Control Center on whitedwarf.
- [Catppuccin](https://github.com/catppuccin/nix) ([docs](https://nix.catppuccin.com)): the Macchiato Mauve theme everywhere.
- [LazyVim](https://github.com/LazyVim/starter): the optional Neovim setup.

Used in the earlier repos and no longer here: [agenix](https://github.com/ryantm/agenix), [Chaotic-Nyx](https://github.com/chaotic-cx/nyx) (CachyOS kernel and packages), and [Lix](https://lix.systems).

Personal configuration: use at your own risk.
