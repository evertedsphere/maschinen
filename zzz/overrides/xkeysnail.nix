{ stdenv, fetchFromGitHub, python3Packages }:

let
  pythonPackages = python3Packages;

in pythonPackages.buildPythonPackage rec {
  name = "${pname}-0.1.0";
  pname = "xkeysnail";

  src = fetchFromGitHub {
    owner = "mooz";
    repo = pname;
    rev = "7ca27e0ada406cfccc5aed051e1a75618fee196b";
    sha256 = "1hv5yb87dx7imizdwmxsfbm9w4q8hck95pn4ndndhngphic1h057";
  };

  propagatedBuildInputs = with pythonPackages; [ 
    xlib
    evdev
    inotify-simple
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mooz/xkeysnail";
    description = "??";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}


