# git, gh, glab. Logins (gh auth login, glab auth login) are done once by hand.
{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "stoutpanda";
      user.email = "stoutpanda@protonmail.com";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = false;
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = {
      editor = "nvim";
      git_protocol = "ssh";
    };
  };

  programs.lazygit.enable = true;
  home.packages = [ pkgs.glab ];
}
