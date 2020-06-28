{ config, pkgs, options, ... }:
let
  home-manager = builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-20.03.tar.gz;
  pinebook-pro = builtins.fetchTarball https://github.com/samueldr/wip-pinebook-pro/archive/master.tar.gz;
in
{
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=${builtins.getEnv ("HOME")}/src/configurations/machines/pinebook-pro/configuration.nix:/nix/var/nix/profiles/per-user/root/channels"
  ];

  imports = [
    "${home-manager}/nixos"
    "${pinebook-pro}/pinebook_pro.nix"
    ../../modules/home.nix
    ../../modules/desktop.nix
    ./hardware-configuration.nix
  ];

  boot = {
    cleanTmpDir = true;
    loader = {
      generic-extlinux-compatible = {
        enable = true;
      };
      grub = {
        enable = false;
      };
    };
  };

  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.zfsSupport = true;
  # boot.loader.grub.copyKernels = true;
  # boot.loader.grub.device = "nodev";
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.initrd.checkJournalingFS = false;
  # boot.supportedFilesystems = [ "zfs" ];

  hardware.sensor.iio.enable = true;

  powerManagement.enable = true;
  #services.tlp.enable = true;
  services.logind.extraConfig = "HandlePowerKey=ignore";

  networking = {
    hostId = "b16be668";
    hostName = "gammu";
    networkmanager.enable = true;
  };

  local = {
    home.git.userEmail = "t@gvno.net";

    desktop = {
      extraPkgs = with pkgs; [
        light
        nfs-utils
        lm_sensors
      ];

      sway = {
        inputs = {
          "9610:30:HAILUCK_CO.,LTD_USB_KEYBOARD" = {
            xkb_layout = "us(dvorak)";
            xkb_variant = ",nodeadkeys";
            xkb_options = "ctrl:nocaps";
          };

          "9610:30:HAILUCK_CO.,LTD_USB_KEYBOARD_Touchpad" = {
            pointer_accel = "0.7";
            tap = "enabled";
            dwt = "enabled";
            natural_scroll = "disabled";
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
  nixpkgs.overlays = [
      (import ../../overlays/panfrost.nix)
  ];
  virtualisation = {
    docker = {
      autoPrune.enable = true;
      enable = true;
    };
  };
  # services.openvpn.servers.moo = {
  #   autoStart = false;
  #   config = "config ${builtins.getEnv ("HOME")}/dev/config/machines/thinkpad/moo.ovpn";
  #   up = "echo nameserver $nameserver | ${pkgs.openresolv}/sbin/resolvconf -m 0 -a $dev";
  #   down = "${pkgs.openresolv}/sbin/resolvconf -d $dev";
  # };

  #security.sudo.extraConfig = ''
  #  %wheel	ALL=(root)	NOPASSWD: ${pkgs.systemd}/bin/systemctl * openvpn-moo
  #'';

  # home-manager.users.tgunnoe = {
  #   programs.chromium = {
  #     enable = true;
  #     extensions = [
  #       #"dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
  #       "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
  #       #"naepdomgkenhinolocfifgehidddafch" # browser-pass
  #     ];
  #   };

  #   xdg.configFile."chromium-flags.conf".text = ''
  #     --force-device-scale-factor=1
  #   '';
  # };

  system.stateVersion = "20.03";
}
