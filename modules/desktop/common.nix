# Everything a desktop host needs that does not depend on the desktop environment:
# audio, bluetooth, printing, fonts, peripherals, browsers, the Bitwarden SSH agent.
# A host never imports this file directly. Each modules/desktop/<ui>.nix imports it.
{ pkgs, ... }:
let
  # Driverless (IPP Everywhere) PPD captured from the Epson with
  # `driverless cat ipp://EPSON5D4BCF.local:631/ipp/print`. It exposes every size, media type
  # and quality the printer reports, and unlike model = "everywhere" it needs no network at boot.
  epsonEt8550Ppd = pkgs.runCommand "epson-et-8550-ppd" { } ''
    install -Dm644 ${./printers/epson-et-8550.ppd} $out/share/cups/model/epson-et-8550.ppd
  '';
in
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

  # Printing and scanning: Brother DCP-7065DN laser and Epson ET-8550 on the home network.
  # Queues are declared below; cups-browsed is off so it does not add duplicate queues.
  services.printing = {
    enable = true;
    browsed.enable = false;
    drivers = with pkgs; [
      brlaser
      hplip
      gutenprint
      epson-escpr
      epson-escpr2
      epsonEt8550Ppd
    ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  # Static PPDs (not "everywhere") so the queues are created even when a printer is offline.
  # Removing a queue from this list does not delete it from CUPS; use `lpadmin -x <name>`.
  hardware.printers = {
    ensureDefaultPrinter = "Brother_DCP-7065DN";
    ensurePrinters = [
      {
        name = "Brother_DCP-7065DN";
        location = "Home";
        deviceUri = "socket://BRN30055C30789E.local:9100";
        model = "drv:///brlaser.drv/br7065d.ppd";
        ppdOptions.PageSize = "Letter";
      }
      {
        name = "Epson_ET-8550";
        location = "Home";
        deviceUri = "ipp://EPSON5D4BCF.local:631/ipp/print";
        model = "epson-et-8550.ppd";
        ppdOptions = {
          PageSize = "Letter";
          cupsPrintQuality = "Normal";
        };
      }
    ];
  };
  hardware.sane = {
    enable = true;
    # Epson scans over eSCL; airscan replaces the built-in escl backend.
    extraBackends = [ pkgs.sane-airscan ];
    disabledDefaultBackends = [ "escl" ];
    brscan4 = {
      enable = true;
      netDevices.brother = {
        model = "DCP-7065DN";
        nodename = "BRN30055C30789E.local";
      };
    };
  };

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
