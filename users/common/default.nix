{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
{
  environment.systemPackages = [
    pkgs.zsh
  ];

  programs.zsh.enable = true;

  users.mutableUsers = false;
  users.defaultUserShell = pkgs.zsh;
}
