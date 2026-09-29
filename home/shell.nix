# fish, starship and the everyday CLI tools.
{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting
      # Bitwarden is the SSH agent. The graphical session gets this from /etc/environment.d;
      # this covers TTY logins. An SSH login keeps the socket sshd forwarded.
      set -q SSH_AUTH_SOCK; or set -gx SSH_AUTH_SOCK ~/.bitwarden-ssh-agent.sock
      fish_add_path ~/.local/bin
    '';
    shellAliases = {
      vim = "nvim";
      cat = "bat --paging=never";
      lg = "lazygit";
      # Rebuild this machine from the repo checkout.
      nrs = "sudo nixos-rebuild switch --flake ~/nixos#(hostname)";
    };
  };

  programs.bash.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      hostname = {
        ssh_only = false;
        format = "[$hostname]($style) ";
      };
      directory.truncation_length = 4;
      git_branch.format = "[$symbol$branch]($style) ";
      nix_shell.format = "[$symbol$state]($style) ";
    };
  };

  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetOptions = [ "--preview 'bat --color=always --line-range=:100 {}'" ];
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
  };

  programs.eza = {
    enable = true;
    git = true;
    icons = "auto";
    extraOptions = [ "--group-directories-first" ];
  };

  programs.zoxide.enable = true;
  programs.bat.enable = true;
  programs.btop.enable = true;
  programs.fastfetch.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    fd
    ripgrep
    tree
    jq
    yq-go
    uv
    rsync
    unzip
    zip
    p7zip
    dnsutils
    mtr
    nmap
    nix-output-monitor
  ];
}
