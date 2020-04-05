{ pkgs, ... }:

# read
# https://github.com/roastiek/overlays/blob/6e1976521222a92a9d0edcbf37fce30cf9187a4f/bobo-laptop-2in1/hardware-configuration.nix

{
  
  boot.cleanTmpDir = true;

  services = {
    ntp.enable = false;
    chrony.enable = true;

    netdata.enable = true;

    sysstat.enable = true;

    openssh = {
      enable = true;
      # FIXME set up ssh yesterday
      permitRootLogin = "yes";
      passwordAuthentication = true;
    };

    thermald = {
      enable = true;
      debug = true;
      # configFile = pkgs.writeText "thermald.conf" "";
    };

    avahi = {
      enable = true;
      nssmdns = true;
    };

    tlp = {
      enable = true;
      extraConfig = ''
        CPU_SCALING_GOVERNOR_ON_BAT=powersave
        CPU_SCALING_GOVERNOR_ON_AC=performance
      '';
    };

    # geoclue2 = { enable = true; };

    gnome3.at-spi2-core.enable = true;
  };
}
