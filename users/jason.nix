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
    # Set interactively during installation: nixos-enter --root /mnt -c 'passwd jason'.
    # The account stays locked until then; subsequent rebuilds preserve the password.
    openssh.authorizedKeys.keyFiles = [ ./jason.pub ];
  };

  home-manager.users.jason = import ../home;
}
