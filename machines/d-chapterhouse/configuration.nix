{ config, pkgs, options, ... }:
let
  home-manager = builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-20.03.tar.gz;
  unstablepkgs = import <nixos-unstable> {};
in
{
  nix = {
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=${builtins.getEnv ("HOME")}/src/configurations/machines/d-chapterhouse/configuration.nix:/nix/var/nix/profiles/per-user/root/channels"
    ];
    # package = pkgs.nixUnstable;
  };
  imports = [
    "${home-manager}/nixos"
    ../../modules/home.nix
    ../../modules/desktop.nix
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-amd" "kvm-intel" ];
    loader = {
      # efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

  # grub = {
  #   enable = true;
  #   version = 2;
  #   device = "/dev/sdb";
  #   efiSupport = true;
  #   useOSProber = true;
  # };
    supportedFilesystems = [ "ntfs" ];
  };

  # boot.cleanTmpDir = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.zfsSupport = true;
  # boot.loader.grub.copyKernels = true;
  # boot.loader.grub.device = "nodev";
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.initrd.checkJournalingFS = false;
  # boot.supportedFilesystems = [ "zfs" ];

  powerManagement.enable = true;
  #services.tlp.enable = true;
  services.logind.extraConfig = "HandlePowerKey=ignore";
  networking = {
    hostId = "e53dd769";
    hostName = "chapterhouse";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 8000 ];
    # wireguard.interfaces = {
    #   # "wg0" is the network interface name. You can name the interface arbitrarily.
    #   wg0 = {
    #     # Determines the IP address and subnet of the client's end of the tunnel interface.
    #     ips = [ "10.100.0.2/24" ];

    #     # Path to the private key file.
    #     #
    #     # Note: The private key can also be included inline via the privateKey option,
    #     # but this makes the private key world-readable; thus, using privateKeyFile is
    #     # recommended.
    #     privateKeyFile = "/home/tgunnoe/wireguard-keys/private";

    #     peers = [
    #       # For a client configuration, one peer entry for the server will suffice.
    #       {
    #         # Public key of the server (not a file path).
    #         publicKey = "fk9gWhGWcWinD9daeZqRURAIPI8oK+1aUlf+xpNQZH0=";

    #         # Forward all the traffic via VPN.
    #         allowedIPs = [ "0.0.0.0/0" ];
    #         # Or forward only particular subnets
    #         #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

    #         # Set this to the server IP and port.
    #         endpoint = "45.33.16.7:51820";

    #         # Send keepalives every 25 seconds. Important to keep NAT tables alive.
    #         persistentKeepalive = 25;
    #       }
    #     ];
    #   };
    # };
  };
  hardware.steam-hardware.enable = true;
  hardware.opengl = {
    enable = true;
    #package = unstablepkgs.mesa.drivers;
    driSupport32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  };
  hardware.pulseaudio.support32Bit = true;
  hardware.bluetooth.enable = true;
  local = {
    home.git.userEmail = "t@gvno.net";

    desktop = {
      extraPkgs = with pkgs; [
        android-studio
        #pkgs.pkgsi686Linux.freetype
        nfs-utils
        ntfs3g
        openjk
        os-prober
        pencil
        postman
        radeontools
        radeontop
        riot-web
        riot-desktop
        #rkdeveloptool
        spotify
        unstablepkgs.lutris
        signal-desktop
        steam
        #steam-run
        #springLobby
        (steam.override {
          extraPkgs = pkgs: [ locale fontconfig iana-etc steamcontroller ];
          #        nativeOnly = true;
        }).run
        tdesktop
        #wine
        wineWowPackages.stable
        winetricks
        protontricks
        torbrowser
        vulkan-loader
        vulkan-tools
        #slack
      ];

      sway = {
        inputs = {
          "1:1:AT_Translated_Set_2_keyboard" = {
            xkb_layout = "us(dvorak)";
            xkb_variant = ",nodeadkeys";
            xkb_options = "ctrl:nocaps";
          };

          "1739:0:Synaptics_TM3381-002" = {
            pointer_accel = "0.7";
            tap = "enabled";
            dwt = "enabled";
            natural_scroll = "enabled";
          };
        };

        outputs = [
          { eDP1 = {};}

          {
            "DP-2" = {
              position = "0,0";
              #transform = "270";
              resolution = "3840x2160";
            };

            "HDMI-A-2" = { position = "1440,470"; };
            "eDP-1" = { position = "1440,1910"; };
          }

          {
            "DP-3" = { position = "450,0"; };
            "DP-4" = { position = "0,1440"; };
            "eDP-1" = { position = "800,2880"; };
          }
        ];

        extraConfig = ''
          bindsym $mod+Print exec slurp | grim -g - - | wl-copy
          workspace 1 output eDP-1
          workspace 2 output DP-1
          workspace 3 output HDMI-A-2
          workspace 4 output eDP-1
          workspace 5 output eDP-1
        '';
      };
    };
  };

  virtualisation = {
    # Anbox doesnt work with kernel 5.7
    # anbox = {
    #   enable = true;
    # };
    docker = {
      autoPrune.enable = true;
      enable = true;
    };
    lxc = {
      enable = true;
    };
    libvirtd = {
      enable = true;
      qemuOvmf = true;
      qemuRunAsRoot = false;
      onBoot = "ignore";
      onShutdown = "shutdown";
    };
    virtualbox = {
      host = {
        enable = true;
      };
    };
  };

  #security.sudo.extraConfig = ''
  #  %wheel	ALL=(root)	NOPASSWD: ${pkgs.systemd}/bin/systemctl * openvpn-moo
  #'';

  home-manager.users.tgunnoe = {
    programs.chromium = {
      enable = true;
      extensions = [
        #"dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
        #"naepdomgkenhinolocfifgehidddafch" # browser-pass
      ];
    };

    xdg.configFile."chromium-flags.conf".text = ''
      --force-device-scale-factor=1
    '';
  };

  system.stateVersion = "20.03";
}
