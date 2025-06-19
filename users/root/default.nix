{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
{
  users.users.root = {
    shell = pkgs.zsh;
    hashedPassword = "$6$RxB792a2NVbNqAn4$94VqhjpjMcZdRU4mAqgg/iphcj0nBJG2nl5W1zdQh9gJuIZFcizzfCowMfQrSN4FrXciLolrY3KQSwDFiwjog1";
  };
}
