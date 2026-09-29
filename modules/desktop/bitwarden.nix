# Bitwarden Desktop as the SSH agent (same as fwaimax and the CachyOS workstation).
# Turn on "Enable SSH agent" in Bitwarden's settings once; the app must be running.
{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.bitwarden-desktop ];

  # The graphical session sees the socket. SSH logins keep whatever sshd forwarded.
  environment.etc."environment.d/10-bitwarden-ssh-agent.conf".text = ''
    SSH_AUTH_SOCK=$HOME/.bitwarden-ssh-agent.sock
  '';

  # Start Bitwarden with the session. A copy in ~/.config/autostart overrides this one.
  environment.etc."xdg/autostart/bitwarden.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Bitwarden
    Comment=Password manager and SSH agent
    Exec=bitwarden --autostart
    StartupNotify=false
    Terminal=false
  '';

  # No OpenSSH agent. Bitwarden owns SSH_AUTH_SOCK.
  programs.ssh.startAgent = false;
}
