self: super:
{
  mesa =
    let
      minVersion = "20.1.5";
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
        sha256 = "fac1861e6e0bf1aec893f8d86dbfb9d8a0f426ff06b05256df10e3ad7e02c69b";
      };
      postFixup = builtins.replaceStrings [
        "rm $dev/lib/pkgconfig/{gl,egl}.pc"
      ] [
        "rm $dev/lib/pkgconfig/gl.pc"
      ] o.postFixup;
    })) else super.mesa;
}
