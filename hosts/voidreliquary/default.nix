# Framework Laptop 13 Pro, Intel Core Ultra Series 3. Main laptop.
# Everything this machine is: pick its desktop, users and optional modules here.
{ ... }:
{
  imports = [
    ./hardware.nix
    ./hardware-configuration.nix
    ./disko.nix
    ../../modules/laptop.nix
    ../../modules/tailscale.nix
    ../../modules/docker.nix
    ../../modules/desktop/plasma.nix
    ../../modules/gaming.nix
    ../../users/jason.nix
  ];

  networking.hostName = "voidreliquary";

  system.stateVersion = "26.05";
}
