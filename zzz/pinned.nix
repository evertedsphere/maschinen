{
  nixpkgs = let
    channelRelease = "nixos-20.09pre218613.ae6bdcc5358";
    channelName = "unstable";
    sha256 = "1aw77y31kh6ippjks5qzz5kqkz6pm5flnhjbp5k598m2pf86id9k";

    url =
      "https://releases.nixos.org/nixos/${channelName}/${channelRelease}/nixexprs.tar.xz";
  in builtins.fetchTarball { inherit url sha256; };

  home-manager = let
    commitHash = "dd93c30";
    sha256 = "0cq6ngagx68rb8w9cyimrl17khr0317m6mazx7fkvqay9qp1pd3y";

    url = "https://github.com/rycee/home-manager/archive/${commitHash}.tar.gz";
    home-manager = builtins.fetchTarball { inherit url sha256; };
  in (import home-manager { });

  nix-user-repository = let
    url =
      "https://github.com/nix-community/NUR/archive/3a6a6f4da737da41e27922ce2cfacf68a109ebce.tar.gz";
    sha256 = "04387gzgl8y555b3lkz9aiw9xsldfg4zmzp930m62qw8zbrvrshd";
  in builtins.fetchTarball { inherit url sha256; };
}

