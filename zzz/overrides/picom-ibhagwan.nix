{ stdenv, lib, fetchFromGitHub, pkgconfig, uthash, asciidoc, docbook_xml_dtd_45
, docbook_xsl, libxslt, libxml2, makeWrapper, meson, ninja, xorgproto, libxcb
, xcbutilrenderutil, xcbutilimage, pixman, libev, dbus, libconfig, libdrm, libGL
, pcre, libX11, libXinerama, libXext, xwininfo, libxdg_basedir }:

stdenv.mkDerivation rec {
  pname = "picom-ibhagwan";
  version = "7.5";

  src = fetchFromGitHub {
    owner = "ibhagwan";
    repo = "picom";
    rev = "aad44d30fab5773da455e01f75acf77055b6ef2d";
    sha256 = "0j17abjiydcm3wnfz9q9147k0g20c94d9p012hh4w4s716mghwqm";

    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    uthash
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    makeWrapper
  ];

  buildInputs = [
    dbus
    libX11
    libXext
    xorgproto
    libXinerama
    libdrm
    pcre
    libxml2
    libxslt
    libconfig
    libGL
    libxcb
    xcbutilrenderutil
    xcbutilimage
    pixman
    libev
    libxdg_basedir
  ];

  NIX_CFLAGS_COMPILE = "-fno-strict-aliasing -Wno-error=format-security";

  mesonBuildType = "release";

  mesonFlags = [ "-Dwith_docs=true" ];

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/picom-trans \
      --prefix PATH : ${lib.makeBinPath [ xwininfo ]}
  '';

  meta = with lib; {
    description =
      "A fork of XCompMgr, a sample compositing manager for X servers";
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

