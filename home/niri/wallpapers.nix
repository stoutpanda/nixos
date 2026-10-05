# Wallpapers for Noctalia, linked one by one into ~/Pictures/Wallpapers (its wallpaper directory).
# Per-file links keep the folder itself writable, so other images can be dropped in next to these.
# Pick one with /wall in the launcher or from the bar's wallpaper panel.
{ pkgs, ... }:
let
  zhichaoh = path: "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/1023077979591cdeca76aae94e0359da1707a60e/${path}";

  # The official niri artwork, recolored to the Macchiato palette at build time.
  niriPool = pkgs.fetchurl {
    name = "niri-pool.png";
    url = "https://raw.githubusercontent.com/niri-wm/artwork/934a61eb463bb107bf1a5f9f2b65c6fd94f393db/wallpapers/Niri%20pool.png";
    hash = "sha256-DaPoByv9c+70tBs2EeEt7TU5xNs+mXj+y/mfcoPHGD4=";
  };
  niriPoolMacchiato = pkgs.runCommand "niri-pool-macchiato.png" { nativeBuildInputs = [ pkgs.lutgen ]; } ''
    lutgen apply -p catppuccin-macchiato --preserve ${niriPool} -o out.png
    cp out.png $out
  '';
in
{
  home.file = {
    # NixOS snowflake on Macchiato base, from nixpkgs. Also the default wallpaper (home/niri.nix).
    "Pictures/Wallpapers/nixos-macchiato.png".source =
      pkgs.nixos-artwork.wallpapers.catppuccin-macchiato.gnomeFilePath;

    # Smooth dark waves; the best blurred overview backdrop.
    "Pictures/Wallpapers/waves-dark.jpg".source = pkgs.fetchurl {
      name = "waves-dark.jpg";
      url = zhichaoh "waves/Waves%20Dark%206016x6016.jpg";
      hash = "sha256-Go5Cq2dIOYDHlnTmthSZBjDsTRdmkelOJa5eb/LEXYg=";
    };

    # Flat geometric design made for the Macchiato flavor.
    "Pictures/Wallpapers/flatppuccin-macchiato.png".source = pkgs.fetchurl {
      url = zhichaoh "flatppuccin/flatppuccin_4k_macchiato.png";
      hash = "sha256-hHqzYNm8XjXvPSsLsbjSUtS6zkNxg5bTnSRQVRzDR4s=";
    };

    "Pictures/Wallpapers/niri-pool-macchiato.png".source = niriPoolMacchiato;
  };
}
