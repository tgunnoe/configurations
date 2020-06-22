self: super:
{
  mesa =
    let
      minVersion = "20.1.0";
    in
    if (self.lib.versionOlder super.mesa.version minVersion) then (super.mesa.overrideAttrs (o:
    let
      version = minVersion;
      branch  = builtins.head (self.lib.splitString "." version);
    in
    {
      inherit version;
      src =  super.fetchurl {
        urls = [
          "ftp://ftp.freedesktop.org/pub/mesa/mesa-${version}.tar.xz"
          "ftp://ftp.freedesktop.org/pub/mesa/${version}/mesa-${version}.tar.xz"
          "ftp://ftp.freedesktop.org/pub/mesa/older-versions/${branch}.x/${version}/mesa-${version}.tar.xz"
          "https://mesa.freedesktop.org/archive/mesa-${version}.tar.xz"
	  "https://archive.mesa3d.org//mesa-${version}.tar.xz"
        ];
        sha256 = "10vwlbdk45qi40kj5bhrc410rc4xpay63n5wq724ylb0frfha291";
      };
      patches = [
    ./missing-includes.patch # dev_t needs sys/stat.h, time_t needs time.h, etc.-- fixes build w/musl
    ./opencl-install-dir.patch
    ./disk_cache-include-dri-driver-path-in-cache-key.patch
  ] # do not prefix user provided dri-drivers-path
    ++ self.lib.optional (self.lib.versionOlder version "19.0.0") (super.fetchpatch {
      url = "https://gitlab.freedesktop.org/mesa/mesa/commit/f6556ec7d126b31da37c08d7cb657250505e01a0.patch";
      sha256 = "0z6phi8hbrbb32kkp1js7ggzviq7faz1ria36wi4jbc4in2392d9";
    })
    ++ self.lib.optionals (self.lib.versionOlder version "19.1.0") [
      # do not prefix user provided d3d-drivers-path
      (super.fetchpatch {
        url = "https://gitlab.freedesktop.org/mesa/mesa/commit/dcc48664197c7e44684ccfb970a4ae083974d145.patch";
        sha256 = "1nhs0xpx3hiy8zfb5gx1zd7j7xha6h0hr7yingm93130a5902lkb";
      })

      # don't build libGLES*.so with GLVND
      (super.fetchpatch {
        url = "https://gitlab.freedesktop.org/mesa/mesa/commit/b01524fff05eef66e8cd24f1c5aacefed4209f03.patch";
        sha256 = "1pszr6acx2xw469zq89n156p3bf3xf84qpbjw5fr1sj642lbyh7c";
      })
    ];

      postFixup = builtins.replaceStrings [
        "rm $dev/lib/pkgconfig/{gl,egl}.pc"
      ] [
        "rm $dev/lib/pkgconfig/gl.pc"
      ] o.postFixup;
    })) else super.mesa;
}
