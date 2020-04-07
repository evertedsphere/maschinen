# most of this file was "inspired" by cleverca22:
# https://github.com/cleverca22/nixos-configs/blob/e25d62b39e16460b83a59763c261deb1ada95839/nixops-managed.nix
{ config, pkgs, ... }:

let
  cfg = pkgs.writeText "configuration.nix" ''
    assert builtins.trace "you're on your ser- i don't care, use nixops!" false;
    {}
  '';
  unstable = import <unstable> { };

in {
  nixpkgs = {
    config.allowUnfree = true;

    config.packageOverrides = pkgs: {
      # nur = import pinned.nix-user-repository { inherit (pinned.nixpkgs) ; };
      inherit unstable;
      xkeysnail = pkgs.callPackage ./overrides/xkeysnail.nix {};
      picom-ibhagwan = pkgs.callPackage ./overrides/picom-ibhagwan.nix { };
      maschinen-system = pkgs.copyPathToStore ./.;
      maschinen-scripts = pkgs.runCommand "maschinen-scripts" {
        xinput = pkgs.xorg.xinput;
        inherit (pkgs) gawk coreutils scrot sox imagemagick i3lock;
      } ''
        cp -r ${../scripts} $out
        chmod -R +w $out
        patchShebangs $out
        substituteAllInPlace $out/polybar-hackspeed.sh
        substituteAllInPlace $out/glitchlock.sh
      '';
    };
  };

  nix.nixPath = [
    # break nixos-rebuild etc
    "nixos-config=${cfg}"
    "nixpkgs=/run/current-system/maschinen-nixpkgs"
    "nixpkgs-overlays=/run/current-system/maschinen-overlays"
    "nixpkgs-unstable=/run/current-system/maschinen-unstable"
  ];

  system.extraSystemBuilderCmds = ''
    ln -sv ${
      builtins.path {
        name = "maschinen-nixpkgs";
        path = pkgs.path;
      }
    } $out/maschinen-nixpkgs
    ln -sv ${./overlays} $out/maschinen-overlays
    ln -sv ${./.} $out/maschinen-system
    ln -sv ${
      builtins.path {
        name = "maschinen-unstable";
        path = unstable.path;
      }
    } $out/maschinen-unstable
  '';
}
