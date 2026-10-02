# Home Manager config shared by all users. Applied by nixos-rebuild; there is no separate home-manager switch.
{ ... }:
{
  imports = [
    ./theme.nix
    ./shell.nix
    ./git.nix
    ./terminal.nix
    ./editor.nix
    ./apps.nix
    ./ai.nix
  ];

  home.stateVersion = "26.05";
}
