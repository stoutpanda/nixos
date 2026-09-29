{ config, pkgs, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Display Manager - greetd with tuigreet
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # XDG Desktop Portal
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Session variables
  environment.sessionVariables = {
    # If cursor invisible
    # WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  # Polkit authentication agent
  security.polkit.enable = true;

  # Essential system packages for Hyprland
  environment.systemPackages = with pkgs; [
    # Core utilities
    waybar
    rofi-wayland
    dunst
    hyprlock
    hyprpaper

    # Screenshot and recording
    grimblast
    grim
    slurp
    wf-recorder

    # Clipboard
    wl-clipboard
    cliphist

    # File management
    kdePackages.dolphin

    # Terminal
    kitty

    # Authentication
    polkit_gnome

    # System utilities
    brightnessctl
    pamixer
    playerctl

    # Network management applet
    networkmanagerapplet

    # Bluetooth management
    blueman

    # Power management
    upower

    # GTK theme management
    gtk3
    gtk4
    qt6.qtwayland
    qt6Packages.qt6ct

    # Notification daemon dependencies
    libnotify

    # Additional Wayland utilities
    wlr-randr
    wdisplays
    wev
  ];

  # Enable required services
  services.dbus.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.udisks2.enable = true;

  # Wayland-specific settings
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Configure fonts for better rendering
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      font-awesome
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };

  # Enable gaming-related features (since you have Steam)
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  # Configure keymap (same as your KDE setup)
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}

