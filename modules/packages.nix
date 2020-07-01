{ pkgs }:

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
  niv
  #nmtui

  yarn
  nodejs

  nomacs

  pavucontrol
  pciutils
  pcmanfm
  pcmanfm-qt

  #pkgsi686Linux.libva

  # PHP
  php
  #phpPackages.platformsh_cli
  phpPackages.composer

  powerline-fonts
  python
  python27Packages.fontforge
  python3
  python37Packages.pip
  qt5.qtwayland


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
  nixops
  nix-prefetch-git
  nix-serve
  nmap
  p7zip
  pass
  rsync
  up

]
