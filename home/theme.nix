# Catppuccin Macchiato, Mauve accent, for every Home Manager program that supports it
# (fish, starship, ghostty, bat, btop, fzf, lazygit, ...). Set once; no theme switching.
# The Plasma desktop theme itself is a one-time step (see modules/desktop/plasma.nix).
{ options, pkgs, ... }:
{
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "macchiato";
    accent = "mauve";

    # The VS Code theme builds with stable's pnpm_10, which nixpkgs marks insecure.
    # Build it with unstable's patched pnpm_10 instead. Drop this once stable catches up.
    sources.vscode = options.catppuccin.sources.default.vscode.override {
      pnpm_10 = pkgs.unstable.pnpm_10;
    };
  };
}
