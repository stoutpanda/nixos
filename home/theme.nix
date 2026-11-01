# Catppuccin Macchiato, Mauve accent, for every Home Manager program that supports it
# (fish, starship, ghostty, bat, btop, fzf, lazygit, ...). Set once; no theme switching.
# The Plasma desktop theme itself is a one-time step (see modules/desktop/plasma.nix).
{ inputs, pkgs, ... }:
let
  ctpSources = (import "${inputs.catppuccin}/default.nix" { inherit pkgs; }).packages;
in
{
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "macchiato";
    accent = "mauve";

    # Temporary: catppuccin/nix's vscode pnpmDeps hash is stale against the pinned nixpkgs.
    # Remove once upstream updates pkgs/vscode/package.nix.
    sources.vscode = ctpSources.vscode.overrideAttrs (old: {
      pnpmDeps = old.pnpmDeps.overrideAttrs {
        outputHash = "sha256-2TEkiwFXUB3Ji4JQRhTF1xJIpHbkrTGolhlcMb1IhmU=";
      };
    });
  };
}
