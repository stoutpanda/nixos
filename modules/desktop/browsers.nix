# Firefox and Google Chrome, configured through enterprise policies instead of
# home-manager profiles. Bitwarden and the Catppuccin theme are force-installed.
# Firefox Sync carries bookmarks and history. Passwords live in Bitwarden, not the browser.
{ pkgs, ... }:
let
  amo = slug: "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
in
{
  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DontCheckDefaultBrowser = true;
      PasswordManagerEnabled = false;
      ExtensionSettings = {
        # Bitwarden Password Manager
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          installation_mode = "force_installed";
          install_url = amo "bitwarden-password-manager";
        };
        # Plasma Browser Integration (media controls, downloads, KDE Connect)
        "plasma-browser-integration@kde.org" = {
          installation_mode = "force_installed";
          install_url = amo "plasma-integration";
        };
        # Catppuccin Macchiato, Mauve accent
        "{998d0435-a079-4dcc-ad24-7333b3463bca}" = {
          installation_mode = "force_installed";
          install_url = "https://github.com/catppuccin/firefox/releases/download/old/catppuccin_macchiato_mauve.xpi";
        };
      };
    };
    nativeMessagingHosts.packages = [ pkgs.kdePackages.plasma-browser-integration ];
    preferences = {
      "media.ffmpeg.vaapi.enabled" = true;
      "media.hardware-video-decoding.force-enabled" = true;
      "signon.rememberSignons" = false;
    };
    # Defaults the user can still change in about:config.
    preferencesStatus = "default";
  };

  # Policies land in /etc/chromium and /etc/opt/chrome, which Google Chrome reads.
  programs.chromium = {
    enable = true;
    enablePlasmaBrowserIntegration = true;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden Password Manager
      "cmpdlhmnmjhihmcfnigoememnffkimlk" # Catppuccin Chrome Theme, Macchiato
    ];
    extraOpts = {
      PasswordManagerEnabled = false;
    };
  };

  environment.systemPackages = with pkgs; [
    google-chrome
  ];
}
