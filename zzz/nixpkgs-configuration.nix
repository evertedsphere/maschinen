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
      picom-ibhagwan = pkgs.callPackage ./picom-ibhagwan.nix { };
      nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only

        exec -a "$0" "$@"
      '';
    };
  };

  nix.nixPath = [ "nixpkgs=${pinned.nixpkgs}" "maschinen=${./.}" ];
}
