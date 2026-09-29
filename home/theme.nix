# Catppuccin Macchiato, Mauve accent, for every Home Manager program that supports it
# (fish, starship, ghostty, bat, btop, fzf, lazygit, ...). Set once; no theme switching.
# The Plasma desktop theme itself is a one-time step (see modules/desktop/plasma.nix).
{ ... }:
{
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "macchiato";
    accent = "mauve";
  };
}
