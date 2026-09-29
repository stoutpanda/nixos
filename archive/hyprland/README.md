# Hyprland (archived, not imported)

The Hyprland setup from the old `stoutpanda/nix-configs` and `stoutpanda/home-manager` repos, kept for reference. Nothing in the flake imports these files.

- `system-hyprland.nix`: from `nix-configs/modules/hyprland.nix`. `programs.hyprland`, greetd + tuigreet, portal, fonts, a large package list.
- `home-hyprland.nix`: from `home-manager/modules/de/hyprland.nix`. Keybinds, gestures, hyprpaper, waybar (with about 120 lines of CSS), rofi, dunst.

State when archived: written for standalone Home Manager behind a `my.desktop.enable` option. It references a `ghostty` flake input, NVIDIA env vars and `rog-control-center`, and hardcodes Catppuccin **Mocha** colors while the rest of the theme was Macchiato. It will not evaluate as-is.

To bring Hyprland back later: add `modules/desktop/hyprland.nix` (programs.hyprland, hyprlock, hypridle) next to `plasma.nix` so both appear at SDDM, and `home/hyprland.nix` with the keybinds from here. Let `catppuccin` theme waybar and Hyprland instead of the hardcoded colors.
