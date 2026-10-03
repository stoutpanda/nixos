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

  # /etc/asusd/asusd.ron. Setting it also creates /etc/asusd, which the asusd unit needs
  # (ReadWritePaths); without the directory the service fails before starting.
  # Every field must be present: a file that fails to parse is renamed asusd.ron-old and
  # replaced with defaults (check `journalctl -u asusd`). Field list is asusctl 6.3.7's
  # asusd/src/config.rs; recheck it when asusctl updates.
  # The file is a writable copy, so changes from asusctl or rog-control-center last until
  # the next rebuild resets them to these values.
  # Fan curves and keyboard lighting are left out; asusd writes this model's defaults for those itself.
  services.asusd.asusdConfig.text = ''
    (
        // Stop charging at 80% to spare a battery that sits on AC. `asusctl battery oneshot`
        // charges to 100% once.
        charge_control_end_threshold: 80,
        base_charge_control_end_threshold: 80,
        disable_nvidia_powerd_on_battery: true,
        ac_command: "",
        bat_command: "",
        // On plug/unplug, switch the platform profile (and the matching CPU EPP below).
        // This overrides whatever was picked in the Plasma battery applet at that moment.
        platform_profile_linked_epp: true,
        platform_profile_on_battery: Quiet,
        change_platform_profile_on_battery: true,
        platform_profile_on_ac: Performance,
        change_platform_profile_on_ac: true,
        profile_quiet_epp: Power,
        profile_balanced_epp: BalancePower,
        profile_custom_epp: Performance,
        profile_performance_epp: Performance,
        ac_profile_tunings: {},
        dc_profile_tunings: {},
        armoury_settings: {},
    )
  '';

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
