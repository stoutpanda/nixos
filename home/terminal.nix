# Ghostty. Catppuccin comes from home/theme.nix.
{ ... }:
{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      font-family = "FiraMono Nerd Font";
      font-size = 11;
      confirm-close-surface = false;
    };
  };
}
