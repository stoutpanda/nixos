# The login user: the NixOS account plus its Home Manager config in ../home.
# A host gets this user by importing this file.
{ pkgs, ... }:
{
  users.users.jason = {
    isNormalUser = true;
    description = "Jason";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "video"
      "audio"
      "input"
      "lp"
      "scanner"
      "openrazer"
    ];
    # Temporary. Change it with `passwd` after first login. Only applied when the user is created.
    initialPassword = "changeme";
    openssh.authorizedKeys.keyFiles = [ ./jason.pub ];
  };

  home-manager.users.jason = import ../home;
}
