{ mkDerivation, base, bytestring, cereal, containers, exceptions
, fetchgit, hashable, lens, megaparsec, monad-logger, mtl
, optparse-applicative, process, stdenv, text, time, unagi-chan
, unix, unliftio, unordered-containers
}:
mkDerivation {
  pname = "kmonad";
  version = "0.2.0";
  src = fetchgit {
    url = "https://github.com/david-janssen/kmonad";
    sha256 = "0d639kjxkcbj36lz1g56nx0fvrh9r2g0sscbb93kpbpvfv4psqyq";
    rev = "13cf1f6178357dfe44772e3d4bebc79be6cc8283";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base bytestring cereal containers exceptions hashable lens
    megaparsec monad-logger mtl optparse-applicative process text time
    unagi-chan unix unliftio unordered-containers
  ];
  executableHaskellDepends = [ base ];
  description = "Advanced keyboard remapping utility";
  license = stdenv.lib.licenses.mit;
  doHaddock = false;
}
