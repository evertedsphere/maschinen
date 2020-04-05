{ stdenv, lib, fetchFromGitHub, pkgconfig, uthash, asciidoc, docbook_xml_dtd_45
, docbook_xsl, libxslt, libxml2, makeWrapper, meson, ninja
, xorgproto, libxcb ,xcbutilrenderutil, xcbutilimage, pixman, libev
, dbus, libconfig, libdrm, libGL, pcre, libX11
, libXinerama, libXext, xwininfo, libxdg_basedir }:

stdenv.mkDerivation rec {
  pname = "picom-ibhagwan";
  version = "7.5";

  src = fetchFromGitHub {
    owner  = "ibhagwan";
    repo   = "picom";
    rev    = "8f9fb151e96dc18f4b1d8c18419be6a6e4b9dcbf";
    sha256 = "1vx6fzr9px9nr9p0d83snzczgzbg7d9j8i184nr4xmc8f8hmb5dy";

    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    meson ninja
    pkgconfig
    uthash
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    makeWrapper
  ];

  buildInputs = [
    dbus libX11 libXext
    xorgproto
    libXinerama libdrm pcre libxml2 libxslt libconfig libGL
    libxcb xcbutilrenderutil xcbutilimage
    pixman libev
    libxdg_basedir
  ];

  NIX_CFLAGS_COMPILE = "-fno-strict-aliasing -Wno-error=format-security";

  mesonBuildType = "release";

  mesonFlags = [
    "-Dwith_docs=true"
  ];

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/picom-trans \
      --prefix PATH : ${lib.makeBinPath [ xwininfo ]}
  '';

  meta = with lib; {
    description = "A fork of XCompMgr, a sample compositing manager for X servers";
    longDescription = ''
      A fork of XCompMgr, which is a sample compositing manager for X
      servers supporting the XFIXES, DAMAGE, RENDER, and COMPOSITE
      extensions. It enables basic eye-candy effects. This fork adds
      additional features, such as additional effects, and a fork at a
      well-defined and proper place.
    '';
    license = licenses.mit;
    homepage = "https://github.com/yshui/picom";
    maintainers = with maintainers; [ ertes enzime twey ];
    platforms = platforms.linux;
  };
}

