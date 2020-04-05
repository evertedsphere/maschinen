{ config, ... }:

let 

  pinned = import ./pinned.nix;

in

{
  nixpkgs = {
    pkgs = import pinned.nixpkgs { inherit (config.nixpkgs) config; };

    config.allowUnfree = true;

    config.packageOverrides = pkgs: {
      # nur = import pinned.nix-user-repository { inherit (pinned.nixpkgs) ; };
      picom-ibhagwan = pkgs.callPackage ./overrides/picom-ibhagwan.nix { };
      glitchlock = pkgs.writeScriptBin "glitchlock" ../scripts/glitchlock;
    };
  };

  nix.nixPath = [ "nixpkgs=${pinned.nixpkgs}" "maschinen=${./.}" ];
}
