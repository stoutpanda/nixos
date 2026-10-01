# Anything a laptop needs that is not tied to one model. Model-specific bits live in hosts/<name>/hardware.nix.
{ ... }:
{
  # Wi-Fi from the Plasma applet. Passwords are stored by NetworkManager on first connect.
  networking.networkmanager.enable = true;

  # Balanced / power-saver / performance, switchable from the Plasma battery applet.
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Suspend on lid close, even on AC power.
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
  };

  services.fstrim.enable = true;
  services.fwupd.enable = true;

  # Suspend only. zram helps under memory pressure; it is not a hibernation target.
  zramSwap.enable = true;
}
