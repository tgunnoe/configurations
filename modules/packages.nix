{ pkgs }:
let
  extra-container = let
    src = builtins.fetchGit {
      url = "https://github.com/erikarvstedt/extra-container.git";
      # Recommended: Specify a git revision hash
      # rev = "...";
    };
  in
    pkgs.callPackage src { pkgSrc = src; };

in

with pkgs; [

  autoconf
  automake
  bchunk
  binutils
  cabextract
  cmake
  cryptsetup
  curl
  docker
  docker-compose
  electrum
  encfs
  f3
  ffmpegthumbnailer #for thumbnails in pcmanfm
  file
  findutils
  #firefox-wayland
  freetype
  gcc
  gimp
  git
  glxinfo
  gnumake
  gparted
  hicolor-icon-theme
  htop
  i3status
  iftop
  inetutils
  inkscape
  ispell
  killall
  kitty
  #kvm
  #libguestfs
  libjpeg
  libusb1
  #libva
  libvdpau
  lsof

  ly
  #maven
  mesa
  mupdf
  ncdu
  #nmtui

  yarn
  nodejs

  nomacs

  pavucontrol
  pciutils
  pcmanfm
  pcmanfm-qt

  #pkgsi686Linux.libva


  powerline-fonts


  ripgrep

  screen
  shared-mime-info
  #signal-cli
  #signal-desktop
  sshfs-fuse

  stress
  subversion
  #tdesktop
  transmission
  usbutils
  wget
  #ycmd
  zip
  unzip
  youtube-dl
  wp-cli
  gnome3.zenity

  ffmpeg-full
  gnupg
  htop
  jq
  mpv

  # Nix-related
  extra-container
  nix-diff
  nix-prefetch-git
  nix-serve
  nixops
  nixos-generators
  niv

  # PHP
  php
  #phpPackages.platformsh_cli
  php73Packages.composer

  # Python
  python
  python27Packages.fontforge
  python3
  python37Packages.pip
  qt5.qtwayland

  nmap
  p7zip
  pass
  rsync
  up

]
