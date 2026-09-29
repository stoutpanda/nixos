# KDE Plasma 6 on Wayland. A host imports exactly one modules/desktop/<ui>.nix.
# Plasma reads its look-and-feel per user; apply it once after first login (see README.md):
#   plasma-apply-lookandfeel -a Catppuccin-Macchiato-Mauve
#   plasma-apply-cursortheme catppuccin-macchiato-mauve-cursors
#   kwriteconfig6 --file kdeglobals --group Icons --key Theme Papirus-Dark
{ pkgs, ... }:
{
  imports = [ ./common.nix ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  # Unlock KWallet at login so Thunderbird and browsers can read stored passwords.
  security.pam.services.sddm.kwallet.enable = true;

  environment.systemPackages = with pkgs; [
    (catppuccin-kde.override {
      flavour = [ "macchiato" ];
      accents = [ "mauve" ];
      winDecStyles = [ "modern" ];
    })
    papirus-icon-theme
    (catppuccin-papirus-folders.override {
      flavor = "macchiato";
      accent = "mauve";
    })
    catppuccin-cursors.macchiatoMauve
    kdePackages.kate
    kdePackages.filelight
  ];
}
