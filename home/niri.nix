# Home Manager side of the niri desktop: Noctalia shell, niri config, wallpapers, GTK theming.
# Attached only by modules/desktop/niri.nix, so it leaves with that import and never reaches Plasma hosts.
{
  config,
  inputs,
  pkgs,
  ...
}:
let
  # Catppuccin Macchiato, Mauve accent, as libadwaita / adw-gtk3 named colors.
  # catppuccin/gtk is archived; adw-gtk3 plus these overrides is the replacement.
  macchiatoGtkCss = ''
    @define-color accent_color #c6a0f6;
    @define-color accent_bg_color #c6a0f6;
    @define-color accent_fg_color #181926;
    @define-color destructive_color #ed8796;
    @define-color destructive_bg_color #ed8796;
    @define-color destructive_fg_color #181926;
    @define-color success_color #a6da95;
    @define-color success_bg_color #a6da95;
    @define-color success_fg_color #181926;
    @define-color warning_color #eed49f;
    @define-color warning_bg_color #eed49f;
    @define-color warning_fg_color #181926;
    @define-color error_color #ed8796;
    @define-color error_bg_color #ed8796;
    @define-color error_fg_color #181926;
    @define-color window_bg_color #24273a;
    @define-color window_fg_color #cad3f5;
    @define-color view_bg_color #1e2030;
    @define-color view_fg_color #cad3f5;
    @define-color headerbar_bg_color #1e2030;
    @define-color headerbar_fg_color #cad3f5;
    @define-color headerbar_backdrop_color #24273a;
    @define-color sidebar_bg_color #1e2030;
    @define-color sidebar_fg_color #cad3f5;
    @define-color sidebar_backdrop_color #24273a;
    @define-color card_bg_color #363a4f;
    @define-color card_fg_color #cad3f5;
    @define-color dialog_bg_color #363a4f;
    @define-color dialog_fg_color #cad3f5;
    @define-color popover_bg_color #363a4f;
    @define-color popover_fg_color #cad3f5;
  '';

  # niri's config plus an optional, unmanaged local.kdl for live experiments.
  # `niri validate` runs at build time, so a broken config fails the rebuild instead of the login.
  niriConfig =
    pkgs.runCommand "niri-config.kdl"
      {
        nativeBuildInputs = [ pkgs.niri ];
        text = ''
          ${builtins.readFile ./niri/config.kdl}
          include optional=true "${config.xdg.configHome}/niri/local.kdl"
        '';
        passAsFile = [ "text" ];
      }
      ''
        cp $textPath $out
        niri validate -c $out
      '';
in
{
  imports = [
    inputs.noctalia.homeModules.default
    ./niri/wallpapers.nix
  ];

  xdg.configFile."niri/config.kdl".source = niriConfig;

  # Written to ~/.config/noctalia/config.toml and validated at build time.
  # Changes made in Noctalia's Settings window go to ~/.local/state/noctalia/settings.toml and win over these.
  # Every key with its default: example.toml in the noctalia repo.
  programs.noctalia = {
    enable = true;
    settings = {
      shell = {
        polkit_agent = true;
        telemetry_enabled = false;
      };

      # Shell colors only. App templates stay off: they rewrite app configs that Home Manager
      # owns read-only, and catppuccin/nix already themes those apps (home/theme.nix).
      theme = {
        mode = "dark";
        source = "community";
        community_palette = "Catppuccin Macchiato Mauve";
        templates = {
          builtin_ids = [ ];
          community_ids = [ ];
        };
      };

      bar.main = {
        position = "top";
        start = [
          "launcher"
          "workspaces"
          "active_window"
        ];
        center = [ "clock" ];
        end = [
          "media"
          "tray"
          "privacy"
          "notifications"
          "network"
          "bluetooth"
          "volume"
          "brightness"
          "power_profile"
          "battery"
          "control-center"
        ];
      };

      control_center.shortcuts = map (type: { inherit type; }) [
        "wifi"
        "bluetooth"
        "notification"
        "caffeine"
        "power_profile"
        "screen_recorder"
      ];

      # logind still suspends on lid close (modules/laptop.nix); Noctalia locks first.
      lockscreen = {
        lock_before_suspend = true;
        fingerprint = true;
      };

      idle.behavior = {
        lock = {
          enabled = true;
          timeout = 300;
          action = "lock";
        };
        screen-off = {
          enabled = true;
          timeout = 600;
          action = "screen_off";
        };
      };

      wallpaper = {
        directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
        default.path = "${config.home.homeDirectory}/Pictures/Wallpapers/nixos-macchiato.png";
      };
      # Blurred copy of the wallpaper behind niri's overview (layer-rule in niri/config.kdl).
      backdrop.enabled = true;

      # Enabled from Noctalia's default official and community git sources, not pinned.
      plugins = {
        enabled = [
          "noctalia/screen_recorder"
          "rylos/tailnet"
          "alexander/game-launcher"
          "kenn/keybind-cheatsheet"
        ];
        auto_update = "all";
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    gtk3.extraCss = macchiatoGtkCss;
    gtk4.extraCss = macchiatoGtkCss;
  };
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  # Papirus-Dark with Mauve folders, and the same cursor Plasma used.
  catppuccin.gtk.icon.enable = true;
  catppuccin.cursors.enable = true;
  home.pointerCursor = {
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
