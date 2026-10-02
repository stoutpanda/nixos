# Everything specific to the Zephyrus GA402X. A different machine replaces this file.
# The nixos-hardware module sets up the AMD iGPU, NVIDIA PRIME offload (run a game with
# `nvidia-offload %command%`) and ASUS quirks.
{ inputs, lib, pkgs, ... }:
{
  imports = [ inputs.nixos-hardware.nixosModules.asus-zephyrus-ga402x-nvidia ];

  # LTS kernel, not linuxPackages_latest: NVIDIA's out-of-tree module lags new kernels
  # (nvidia-open 595 failed to build against 7.2). Build and test NVIDIA, peripherals,
  # and suspend before moving to a newer kernel.
  boot.kernelPackages = pkgs.linuxPackages;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.enableRedistributableFirmware = true;

  # ASUS control: fan curves, charge limit, keyboard LEDs (asusctl, rog-control-center).
  services.asusd.enable = true;
  services.supergfxd.enable = true;
  programs.rog-control-center.enable = true;

  # Boot menu entry with the NVIDIA GPU fully off, for battery life away from a charger.
  specialisation.power-saving.configuration = {
    hardware.nvidiaOptimus.disable = true;
    hardware.nvidia = {
      prime.offload.enable = lib.mkForce false;
      prime.offload.enableOffloadCmd = lib.mkForce false;
      prime.sync.enable = lib.mkForce false;
    };
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };
}
