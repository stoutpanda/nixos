# niri (scrollable tiling Wayland) with the Noctalia shell and greeter. A host imports exactly one modules/desktop/<ui>.nix;
# swapping this import back to plasma.nix restores Plasma. User config (Noctalia, niri keybinds, theming) is home/niri.nix.
{ inputs, pkgs, ... }:
{
  imports = [
    ./common.nix
    inputs.noctalia-greeter.nixosModules.default
  ];

  # Also enables gnome-keyring, the GNOME portal (Nautilus file chooser) and polkit.
  # The polkit agent is Noctalia's own (shell.polkit_agent in home/niri.nix).
  programs.niri.enable = true;

  # Login screen. Wallpaper and palette sync from Noctalia: Settings > Security > Noctalia Greeter.
  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      session.default = "Niri";
      user.default = "jason";
      appearance.scheme = "Synced";
    };
    passwordless-sync-users = [ "jason" ];
  };

  # Password at the greeter so it can unlock gnome-keyring; a fingerprint login would leave it locked.
  # Fingerprint still works on Noctalia's lock screen (PAM login), sudo and polkit.
  security.pam.services.greetd = {
    fprintAuth = false;
    enableGnomeKeyring = true;
    # Signal keeps its key in KWallet (home/apps.nix); unlock it at login as well.
    kwallet.enable = true;
  };
  programs.seahorse.enable = true;
  # The Bitwarden SSH agent stays in charge of SSH_AUTH_SOCK (bitwarden.nix).
  services.gnome.gcr-ssh-agent.enable = false;

  # Noctalia's binary cache. Only takes effect after the first switch that includes it.
  nix.settings = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  # Trash, MTP phones and SMB shares in Nautilus.
  services.gvfs.enable = true;
  # For Noctalia's screen recorder plugin.
  programs.gpu-screen-recorder.enable = true;

  environment.systemPackages = with pkgs; [
    # niri runs X11 apps (Steam, older games) through xwayland-satellite when it is on PATH.
    xwayland-satellite
    # GNOME apps in place of Plasma's Dolphin, Ark, Gwenview, Okular, Filelight and Kate.
    nautilus
    file-roller
    loupe
    papers
    baobab
    gnome-text-editor
    # KWallet daemon for Signal; kwallet-pam's autostart entry hands it the login password.
    kdePackages.kwallet
    kdePackages.kwallet-pam
  ];
  services.dbus.packages = [ pkgs.kdePackages.kwallet ];

  home-manager.users.jason.imports = [ ../../home/niri.nix ];
}
