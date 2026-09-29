# Neovim and VS Code.
# Neovim: Home Manager installs it; the config in ~/.config/nvim is yours. For LazyVim, clone the
# starter once: git clone https://github.com/LazyVim/starter ~/.config/nvim
# (nix-ld in modules/base.nix lets Mason-installed language servers run.)
{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    extraPackages = with pkgs; [
      gcc
      gnumake
      nodejs
      tree-sitter
    ];
  };

  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      ms-python.python
    ];
  };
}
