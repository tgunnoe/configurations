{ config, pkgs, options, ... }:
let
  home-manager = builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-20.09.tar.gz;
  nixos-20-09 = builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/96052f35023070072cd5ac0f17a97a2a2269d5b9.tar.gz;
  nixos-unstable = builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/b839d4a8557adc80e522f674529e586ab2a88d23.tar.gz;
in
{
  nix = {
    nixPath = [
      "nixpkgs=${nixos-20-09}"
      "nixos-config=${builtins.getEnv ("HOME")}/src/configurations/machines/l-arrakis/configuration.nix:/nix/var/nix/profiles/per-user/root/channels"
    ];
    # package = pkgs.nixUnstable;
  };
  nixpkgs.config.allowUnfree = true;
  imports = [
    "${home-manager}/nixos"
    ../../modules/home.nix
    ../../modules/desktop.nix
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-intel" ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        device = "nodev";
        version = 2;
        efiSupport = true;
        enableCryptodisk = true;
      };
    };
    initrd = {
      secrets = {
        "/keyfile0.bin" = "/etc/secrets/initrd/keyfile0.bin";
      };
      luks.devices = {
        root = {
          name = "root";
          device = "/dev/disk/by-uuid/f33695e2-5719-44e7-bf2b-58b28eeca5ae";
          preLVM = true;
          keyFile = "/keyfile0.bin";
          allowDiscards = true;
        };
      };
    };
    supportedFilesystems = [ "ntfs" ];
  };
  console = {
      keyMap = "dvorak";
      earlySetup = true;
  };

  powerManagement.enable = true;
  services.tlp.enable = true;
  services.logind.extraConfig = "HandlePowerKey=ignore";
  services.thermald.enable = true;
  services.hdapsd.enable = true;
  networking = {
    hostId = "1e0adfe3";
    hostName = "arrakis";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 8000 ];
    useDHCP = false;
    interfaces.wlp58s0.useDHCP = true;
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

  hardware.opengl = {
    enable = true;
    #package = unstablepkgs.mesa.drivers;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  };
  hardware.pulseaudio.support32Bit = true;
  hardware.bluetooth.enable = true;
  local = {
    home.git.userEmail = "t@gvno.net";

    desktop = {
      extraPkgs = with pkgs; [
        #pkgs.pkgsi686Linux.freetype
        nfs-utils
        ntfs3g
        openjk
        os-prober
        pencil

        radeontools
        radeontop

        #spotify
        lutris
        signal-desktop
        steam
        #steam-run
        #springLobby
        (steam.override {
          extraPkgs = pkgs: [ locale fontconfig iana-etc ];
          nativeOnly = true;
        }).run
        tdesktop
        #wine
        wineWowPackages.stable
        winetricks
        protontricks
        #torbrowser
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

          {
            "eDP-2" = {
              position = "0,0";
              #transform = "270";
              resolution = "3200x1800";
            };

            "HDMI-A-2" = { position = "1440,470"; };
            "eDP-1" = { position = "1440,1910"; };
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

  system.stateVersion = "20.09";
}
