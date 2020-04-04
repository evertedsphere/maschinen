{ ... }:

{
  # Select internationalisation properties.
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # TODO set currency etc
  # TODO should we do this at the home-manager level?
  # probably not but still
  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";
}
