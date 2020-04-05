{ config, ... }:

let

  pinned = import ./pinned.nix;

in {
  nixpkgs = {
    pkgs = import pinned.nixpkgs { inherit (config.nixpkgs) config; };

    config.allowUnfree = true;

    config.packageOverrides = pkgs: {
      # nur = import pinned.nix-user-repository { inherit (pinned.nixpkgs) ; };
      picom-ibhagwan = pkgs.callPackage ./overrides/picom-ibhagwan.nix { };
      glitchlock = pkgs.writeScriptBin "glitchlock" ../scripts/glitchlock.sh;
      system-config-src = pkgs.copyPathToStore ./.;
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

  nix.nixPath = [ "nixpkgs=${pinned.nixpkgs}" ];
}
