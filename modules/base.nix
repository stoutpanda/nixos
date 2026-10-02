# Shared by every host. Nothing hardware-specific here.
{ pkgs, ... }:
{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "@wheel" ];
      # Prebuilt llm-agents packages (overlays/llm-agents.nix).
      extra-substituters = [ "https://cache.numtide.com" ];
      extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  # System-level Catppuccin: TTY palette, SDDM, and anything else the NixOS module covers.
  # User apps (fish, starship, ghostty, bat, btop...) are themed in home/theme.nix.
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "macchiato";
    accent = "mauve";
  };

  # fish must be enabled system-wide to be a login shell. Its config lives in home/shell.nix.
  programs.fish.enable = true;

  # Run prebuilt binaries (uv-installed tools, npm packages, Claude Code updates) without patching.
  programs.nix-ld.enable = true;

  # Only what root and services need. User tools live in home/.
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    pciutils
    usbutils
  ];

  environment.variables.EDITOR = "vim";
}
