# Everything a desktop host needs that does not depend on the desktop environment:
# audio, bluetooth, printing, fonts, peripherals, browsers, the Bitwarden SSH agent.
# A host never imports this file directly. Each modules/desktop/<ui>.nix imports it.
{ pkgs, ... }:
{
  imports = [
    ./browsers.nix
    ./bitwarden.nix
  ];

  # Audio
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Printing and scanning: Brother laser, HP, Epson. Printers are found over mDNS.
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      brlaser
      hplip
      gutenprint
      epson-escpr
      epson-escpr2
    ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  hardware.sane.enable = true;

  # Razer peripherals (polychromatic is the GUI). The user needs the openrazer group.
  hardware.openrazer.enable = true;

  # ZSA keyboards (Moonlander, Voyager) and their flashing tools.
  hardware.keyboard.zsa.enable = true;

  # Electron and Chromium apps run native Wayland.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.fira-mono
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    wl-clipboard
    vulkan-tools
    polychromatic
    keymapp
    simple-scan
  ];
}
