# ASUS ROG Zephyrus G14 (GA402X): Ryzen 7040 + NVIDIA RTX 4060. Second laptop.
# Defined now, installed after voidreliquary has settled.
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

  networking.hostName = "whitedwarf";

  system.stateVersion = "26.05";
}
