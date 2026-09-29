# Steam, a gamescope session at the login screen, other launchers, and controller support. Optional per host.
{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  # Xbox controllers over Bluetooth.
  hardware.xpadneo.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-qt
    protontricks
    heroic
    lutris
  ];
}
