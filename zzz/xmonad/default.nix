{ mkDerivation, base, containers, stdenv, xmonad, xmonad-contrib
, xmonad-extras
}:
mkDerivation {
  pname = "evsph-xmonad";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [
    base containers xmonad xmonad-contrib xmonad-extras
  ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
