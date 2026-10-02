# Second login user on moonflower: the NixOS account plus the shared Home Manager config in ../home.
# A host gets this user by importing this file.
{ pkgs, ... }:
{
  users.users.ashtrix = {
    isNormalUser = true;
    description = "Ashtrix";
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
    # Applied only when the account is first created; change it at first login with `passwd`.
    # Subsequent rebuilds preserve whatever password was set.
    initialPassword = "changeme";
  };

  home-manager.users.ashtrix = import ../home;
}
