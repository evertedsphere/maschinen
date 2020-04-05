# most of this file was "inspired" by cleverca22:
# https://github.com/cleverca22/nixos-configs/blob/e25d62b39e16460b83a59763c261deb1ada95839/nixops-managed.nix
{ config, pkgs, ... }:

let
  cfg = pkgs.writeText "configuration.nix" ''
    assert builtins.trace "you're on your ser- i don't care, use nixops!" false;
    {}
  '';

in {
  nixpkgs = {
    config.allowUnfree = true;

    config.packageOverrides = pkgs: {
      # nur = import pinned.nix-user-repository { inherit (pinned.nixpkgs) ; };
      picom-ibhagwan = pkgs.callPackage ./overrides/picom-ibhagwan.nix { };
      glitchlock = pkgs.writeScriptBin "glitchlock" ../scripts/glitchlock.sh;
      maschinen-system = pkgs.copyPathToStore ./.;
      maschinen-scripts = pkgs.runCommand "maschinen-scripts" {
        xinput = pkgs.xorg.xinput;
        gawk = pkgs.gawk;
        coreutils = pkgs.coreutils;
      } ''
        cp -r ${../scripts} $out
        chmod -R +w $out
        patchShebangs $out
        substituteAllInPlace $out/polybar-hackspeed.sh
      '';
    };
  };

  nix.nixPath = [ 
    "nixos-config=${cfg}"
    "nixpkgs=/run/current-system/nixpkgs"
    "nixpkgs-overlays=/run/current-system/overlays"
    "maschinen-system=/run/current-system/maschinen-system"
  ];

  system.extraSystemBuilderCmds = ''
    ln -sv ${builtins.path { name = "current-nixpkgs"; path = pkgs.path; }} $out/nixpkgs
    ln -sv ${./overlays} $out/overlays
    ln -sv ${./.} $out/maschinen-system
  '';
}
