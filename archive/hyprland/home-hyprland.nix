{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$fileManager" = "dolphin";
      "$menu" = "rofi -show drun";
      "$browser" = "firefox";

      # Monitor configuration - adjust as needed
      monitor = ",preferred,auto,2";
      
      # Environment variables for better performance
      env = [
        "XCURSOR_SIZE,24"
        "WLR_DRM_NO_ATOMIC,1"
        "WLR_RENDERER_ALLOW_SOFTWARE,1"
        "__GL_GSYNC_ALLOWED,1"
        "__GL_VRR_ALLOWED,1"
        "WLR_DRM_NO_ATOMIC,1"
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];

      # Execute on startup
      exec-once = [
        "waybar"
        "hyprpaper"
        "dunst"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "nm-applet --indicator"
        "blueman-applet"
        "obsidian"
        "rog-control-center"
      ];

      # Input configuration
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
        sensitivity = 0;
      };

      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(cba6f7ee) rgba(f5c2e7ee) 45deg";
        "col.inactive_border" = "rgba(6c7086aa)";
        layout = "dwindle";
        allow_tearing = false;
      };

      # Decoration
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 6;
          passes = 3;
          new_optimizations = true;
          xray = true;
          contrast = 1.0;
          brightness = 1.0;
          noise = 0.02;
        };
        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
          color = "rgba(1a1a2aee)";
          offset = "0 15";
        };
        active_opacity = 0.95;
        inactive_opacity = 0.9;
        fullscreen_opacity = 1.0;
      };

      # Animations - minimal and fast
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 2, myBezier"
          "windowsOut, 1, 2, default, popin 80%"
          "border, 1, 3, default"
          "borderangle, 1, 2, default"
          "fade, 1, 2, default"
          "workspaces, 1, 2, default"
        ];
      };

      # Layouts
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      # Gestures
      gestures = {
        workspace_swipe = true;
      };

      # Misc
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        vfr = true; # Variable frame rate - saves battery
        vrr = 1; # Variable refresh rate
        mouse_move_enables_dpms = true; # Wake screen on mouse move
        key_press_enables_dpms = true; # Wake screen on key press
        enable_swallow = true; # Window swallowing
        swallow_regex = "^(kitty|ghostty|alacritty)$";
      };

      # Window rules for workspace assignment
      windowrulev2 = [
        # Workspace 1: Terminal/Development
        "workspace 1, class:^(kitty)$"
        "workspace 1, class:^(Alacritty)$"
        "workspace 1, class:^(ghostty)$"
        
        # Workspace 2: Web Browser
        "workspace 2, class:^(firefox)$"
        "workspace 2, class:^(brave-browser)$"
        "workspace 2, class:^(chromium-browser)$"
        "workspace 2, class:^(zen-alpha)$"
        
        # Workspace 3: Communication
        "workspace 3, class:^(discord)$"
        "workspace 3, class:^(Signal)$"
        "workspace 3, class:^(telegram-desktop)$"
        "workspace 3, class:^(thunderbird)$"
        
        # Workspace 4: File Management
        "workspace 4, class:^(dolphin)$"
        "workspace 4, class:^(org.kde.ark)$"
        
        # Workspace 5: Media
        "workspace 5, class:^(mpv)$"
        "workspace 5, class:^(vlc)$"
        "workspace 5, class:^(spotify)$"
        
        # Workspace 6: Documents
        "workspace 6, class:^(libreoffice)$"
        "workspace 6, class:^(okular)$"
        "workspace 6, class:^(evince)$"
        "workspace 6, class:^(obsidian)$"
        
        # Workspace 7: Development Tools
        "workspace 7, class:^(code)$"
        "workspace 7, class:^(jetbrains)$"
        
        # Workspace 8: System Tools
        "workspace 8, class:^(pavucontrol)$"
        "workspace 8, class:^(nm-connection-editor)$"
        
        # Workspace 9: Gaming
        "workspace 9, class:^(Steam)$"
        "workspace 9, class:^(steam)$"
        "workspace 9, class:^(heroic)$"
        
        # Workspace 10: System Control
        "workspace 10, class:^(rog-control-center)$"
        
        # Float rules
        "float, class:^(pavucontrol)$"
        "float, class:^(nm-connection-editor)$"
        "float, class:^(blueman-manager)$"
        "float, title:^(Media viewer)$"
        "float, title:^(Volume Control)$"
        "float, class:^(Lxappearance)$"
        "float, class:^(.blueman-manager-wrapped)$"
        "float, class:^(qt5ct)$"
        "float, class:^(qt6ct)$"
        
        # Size rules for floating windows
        "size 800 600, class:^(pavucontrol)$"
        "center, class:^(pavucontrol)$"
        
        # Opacity rules
        "opacity 0.9 0.85, class:^(kitty)$"
        "opacity 0.9 0.85, class:^(ghostty)$"
        "opacity 0.95 0.9, class:^(code)$"
        "opacity 0.95 0.9, class:^(obsidian)$"
        
        # Animation rules
        "animation slide, class:^(rofi)$"
        "animation popin 80%, class:^(dolphin)$"
        
        # Gaming rules
        "fullscreen, class:^(steam_app).*"
        "immediate, class:^(steam_app).*"
        "noblur, class:^(steam_app).*"
        "noshadow, class:^(steam_app).*"
        
        # Picture-in-Picture
        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
        "size 640 360, title:^(Picture-in-Picture)$"
        "move 100%-660 100%-380, title:^(Picture-in-Picture)$"
      ];

      # Keybindings
      bind = [
        # Main bindings
        "$mod, T, exec, $terminal"
        "$mod, Q, killactive"
        "$mod SHIFT, Q, exit"
        "$mod, E, exec, $fileManager"
        "$mod, V, togglefloating"
        "$mod, Space, exec, $menu"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        "$mod, F, fullscreen"
        
        # Move focus with mod + vim keys
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        
        # Move windows with mod + shift + vim keys
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"
        
        # Resize windows with mod + alt + vim keys
        "$mod ALT, H, resizeactive, -20 0"
        "$mod ALT, L, resizeactive, 20 0"
        "$mod ALT, K, resizeactive, 0 -20"
        "$mod ALT, J, resizeactive, 0 20"
        
        # Switch workspaces with mod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        
        # Move active window to workspace with mod + shift + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        
        # Special workspace (scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        
        # Scroll through existing workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
        
        # Screenshot bindings
        ", Print, exec, grimblast copy area"
        "SHIFT, Print, exec, grimblast copy screen"
        "$mod, Print, exec, grimblast save area"
        
        # Media keys
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        
        # Brightness
        ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
        
        # Lock screen
        "$mod, X, exec, hyprlock"
        
        # Browser
        "$mod, B, exec, $browser"
        
        # Clipboard history
        "$mod, C, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
        
        # Window management
        "$mod, Tab, cyclenext"
        "$mod SHIFT, Tab, cyclenext, prev"
        "$mod, G, togglegroup"
        "$mod SHIFT, G, changegroupactive"
        "$mod, R, exec, hyprctl reload"
        "$mod SHIFT, F, togglefloating"
        "$mod, O, fullscreenstate, 2"
        
        # Layout switching
        "$mod, D, exec, hyprctl keyword general:layout dwindle"
        "$mod, M, exec, hyprctl keyword general:layout master"
      ];
      
      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  # Hyprpaper configuration
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ~/Documents/wallpapers/wallpaper.png
    wallpaper = ,~/Documents/wallpapers/wallpaper.png
    splash = false
    ipc = off
  '';

  # Waybar configuration
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;
        spacing = 4;
        margin-top = 5;
        margin-left = 10;
        margin-right = 10;
        
        modules-left = ["hyprland/workspaces" "hyprland/submap" "custom/separator" "hyprland/window"];
        modules-center = ["clock" "custom/weather"];
        modules-right = ["idle_inhibitor" "backlight" "pulseaudio" "network" "cpu" "memory" "temperature" "battery" "custom/notification" "tray"];
        
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "";
            "8" = "";
            "9" = "";
            "10" = "";
            urgent = "";
            active = "";
            default = "";
          };
          persistent-workspaces = {
            "*" = [1 2 3 4 5];
          };
          on-click = "activate";
        };
        
        "hyprland/window" = {
          max-length = 50;
          separate-outputs = true;
          rewrite = {
            "(.*) — Mozilla Firefox" = "🌐 $1";
            "(.*) - ghostty" = " $1";
            "(.*) - Dolphin" = "📁 $1";
            "(.*) - Discord" = "💬 $1";
          };
        };
        
        "hyprland/submap" = {
          format = "<span style=\"italic\">{}</span>";
          tooltip = false;
        };
        
        "custom/separator" = {
          format = "|";
          interval = "once";
          tooltip = false;
        };
        
        clock = {
          timezone = "America/Chicago";
          interval = 1;
          format = " {:%H:%M:%S}";
          format-alt = " {:%A, %B %d, %Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
        
        "custom/weather" = {
          exec = "curl -s 'wttr.in/?format=1'";
          interval = 3600;
          format = "{}";
        };
        
        cpu = {
          format = " {usage}%";
          interval = 2;
          format-alt = " {avg_frequency} GHz";
          tooltip = true;
          tooltip-format = "Load: {load}\nFrequency: {avg_frequency} GHz";
        };
        
        memory = {
          interval = 2;
          format = " {percentage}%";
          format-alt = " {used:0.1f}G/{total:0.1f}G";
          tooltip = true;
          tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G\nSwap: {swapUsed:0.1f}G / {swapTotal:0.1f}G";
        };
        
        temperature = {
          thermal-zone = 2;
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format = " {temperatureC}°C";
          format-critical = " {temperatureC}°C";
          tooltip = true;
        };
        
        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = ["" "" "" "" ""];
          tooltip = true;
          tooltip-format = "{capacity}% - {timeTo}\nPower: {power}W";
        };
        
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          tooltip = true;
          tooltip-format-activated = "Idle inhibitor active";
          tooltip-format-deactivated = "Idle inhibitor inactive";
        };
        
        "backlight" = {
          format = "{icon} {percent}%";
          format-icons = [""];
          on-scroll-up = "brightnessctl set +5%";
          on-scroll-down = "brightnessctl set 5%-";
          tooltip = true;
        };
        
        network = {
          format-wifi = " {signalStrength}%";
          format-ethernet = " {ipaddr}";
          format-linked = " {ifname}";
          format-disconnected = " Disconnected";
          format-alt = "{essid} ({signalStrength}%)";
          tooltip = true;
          tooltip-format = "Interface: {ifname}\nIP: {ipaddr}\nGateway: {gwaddr}\nSSID: {essid}\nFrequency: {frequency} MHz\nSignal: {signalStrength}%";
          on-click-right = "nm-connection-editor";
        };
        
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}% ";
          format-bluetooth-muted = " ";
          format-muted = "";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
          on-click-right = "pamixer -t";
          on-scroll-up = "pamixer -i 5";
          on-scroll-down = "pamixer -d 5";
          tooltip = true;
          tooltip-format = "{desc} - {volume}%";
        };
        
        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
          };
          return-type = "json";
          exec = ''
            dbus-monitor "interface='org.freedesktop.Notifications'" |
            grep --line-buffered "string" |
            grep --line-buffered -e method_call -e ":" |
            grep --line-buffered "member=Notify" |
            sed -u -e 's/^.*$/{"class": "notification"}/g' -e '1s/^.*$/{"class": "none"}/g'
          '';
          on-click = "dunstctl history-pop";
          on-click-right = "dunstctl close-all";
        };
        
        tray = {
          icon-size = 18;
          spacing = 10;
          reverse-direction = true;
        };
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }
      
      window#waybar {
        background: transparent;
        color: #cdd6f4;
      }
      
      .modules-left,
      .modules-center,
      .modules-right {
        background: rgba(30, 30, 46, 0.85);
        border-radius: 10px;
        padding: 0 10px;
        margin: 0 5px;
      }
      
      #workspaces button {
        padding: 0 8px;
        margin: 0 2px;
        color: #cdd6f4;
        background: transparent;
        border: none;
        border-radius: 8px;
        transition: all 0.3s ease;
      }
      
      #workspaces button:hover {
        background: rgba(108, 112, 134, 0.5);
        box-shadow: inset 0 -3px #cba6f7;
      }
      
      #workspaces button.active {
        background: rgba(203, 166, 247, 0.2);
        color: #cba6f7;
        box-shadow: inset 0 -3px #cba6f7;
      }
      
      #workspaces button.urgent {
        background: rgba(243, 139, 168, 0.2);
        color: #f38ba8;
        animation: urgent-blink 1s linear infinite;
      }
      
      @keyframes urgent-blink {
        50% { background: rgba(243, 139, 168, 0.4); }
      }
      
      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #backlight,
      #tray,
      #idle_inhibitor,
      #custom-weather,
      #custom-notification {
        padding: 0 10px;
        margin: 0 2px;
      }
      
      #window {
        margin-left: 10px;
        font-weight: 500;
      }
      
      #battery.charging {
        color: #a6e3a1;
      }
      
      #battery.warning:not(.charging) {
        color: #f9e2af;
      }
      
      #battery.critical:not(.charging) {
        background-color: #f38ba8;
        color: #1e1e2e;
        animation: critical-blink 1s linear infinite;
      }
      
      @keyframes critical-blink {
        50% { background-color: rgba(243, 139, 168, 0.5); }
      }
      
      #network.disconnected {
        color: #f38ba8;
      }
      
      #pulseaudio.muted {
        color: #6c7086;
      }
      
      #temperature.critical {
        color: #f38ba8;
      }
      
      #idle_inhibitor.activated {
        color: #f9e2af;
      }
      
      #custom-separator {
        color: #6c7086;
        margin: 0 5px;
      }
      
      tooltip {
        background: rgba(30, 30, 46, 0.95);
        border: 1px solid #cba6f7;
        border-radius: 10px;
      }
      
      tooltip label {
        color: #cdd6f4;
      }
    '';
  };

  # Rofi configuration
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "${pkgs.ghostty}/bin/ghostty";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window";
      sidebar-mode = true;
    };
  };
  
  # Enable Catppuccin theming for Rofi
  catppuccin.rofi.enable = true;

  # Dunst configuration
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = 300;
        height = 300;
        origin = "top-right";
        offset = "10x50";
        scale = 0;
        notification_limit = 0;
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        indicate_hidden = "yes";
        transparency = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 3;
        frame_color = "#89b4fa";
        separator_color = "frame";
        sort = "yes";
        font = "JetBrainsMono Nerd Font 10";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 32;
        sticky_history = "yes";
        history_length = 20;
        always_run_script = true;
        corner_radius = 10;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };
      
      urgency_low = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 10;
      };
      
      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 10;
      };
      
      urgency_critical = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        frame_color = "#f38ba8";
        timeout = 0;
      };
    };
  };
}
