# Home Manager config for jason. Applied by nixos-rebuild; there is no separate home-manager switch.
{ ... }:
{
  imports = [
    ./theme.nix
    ./shell.nix
    ./git.nix
    ./terminal.nix
    ./editor.nix
    ./apps.nix
  ];

  home.username = "jason";
  home.homeDirectory = "/home/jason";

  home.stateVersion = "26.05";
}
