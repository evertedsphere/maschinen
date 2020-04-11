{ config, pkgs, ... }:

let

  systemConstants = {
    zfs_arc_min = 2147483648;
    zfs_arc_max = 4294967296;
  };

in {
  # "set font size earlier in the boot process"
  # https://discourse.nixos.org/t/settings-for-increasing-text-mode-font-size/2849/3
  console.earlySetup = true;

  boot = {
    # kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "elevator=noop" ];

    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # ZFS/filesystem configuration

    supportedFilesystems = [ "zfs" ];
    initrd.supportedFilesystems = [ "zfs" ];
    zfs.enableUnstable = true;
    zfs.forceImportRoot = false;
    zfs.forceImportAll = false;
  };

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "daily";
    };
    trim = {
      enable = true;
      interval = "daily";
    };
    autoSnapshot = {
      enable = true;
      frequent = 8;
    };
  };

  fileSystems."/home".neededForBoot = true;

}
