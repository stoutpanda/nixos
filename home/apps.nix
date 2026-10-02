# Desktop apps. Add a line when you reach for something; remove it when you stop.
# Anything that needs a login (Thunderbird mail accounts, Discord, Teams, Obsidian sync)
# is set up in the app on first run. Nothing secret lives in this repo.
{ pkgs, ... }:
{
  programs.thunderbird = {
    enable = true;
    profiles.default.isDefault = true;
  };
  catppuccin.thunderbird.profile = "default";

  programs.rbw.enable = true; # Bitwarden CLI: rbw config set email ..., then rbw get <name>

  home.packages = with pkgs; [
    obsidian
    discord
    vlc
    remmina
    gimp
    teams-for-linux
    hexchat
    teamspeak6-client
    rpi-imager
  ];
}
