{ mkDerivation, base, containers, stdenv, X11, xmonad, xmonad-contrib
, xmonad-extras }:
mkDerivation {
  pname = "evsph-xmonad";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends =
    [ base containers X11 xmonad xmonad-contrib xmonad-extras ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
