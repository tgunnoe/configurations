{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-19.09.tar.gz;
in
{
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=${builtins.getEnv ("HOME")}/dev/config/machines/thinkpad/configuration.nix:/nix/var/nix/profiles/per-user/root/channels"
  ];

  imports = [
    "${home-manager}/nixos"
    ../../modules/home.nix
    ../../modules/desktop.nix
    ./hardware-configuration.nix
  ];

  boot.cleanTmpDir = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.checkJournalingFS = false;
  boot.supportedFilesystems = [ "zfs" ];

  powerManagement.enable = true;
  services.tlp.enable = true;
  services.logind.extraConfig = "HandlePowerKey=ignore";

  networking = {
    hostId = "9938e3e0";
    hostName = "thinkpad";
    networkmanager.enable = true;
  };

  local = {
    home.git.userEmail = "calum.macrae@moo.com";

    desktop = {
      extraPkgs = with pkgs; [
        awscli
        aws-iam-authenticator
        docker-compose
        eksctl
        kubernetes
        minikube
        nfs-utils
        pantheon.elementary-files
        slack
      ];

      sway = {
        inputs = {
          "1:1:AT_Translated_Set_2_keyboard" = {
            xkb_layout = "gb";
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
            "DP-1" = {
              position = "0,0";
              transform = "270";
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

  services.openvpn.servers.moo = {
    autoStart = false;
    config = "config ${builtins.getEnv ("HOME")}/dev/config/machines/thinkpad/moo.ovpn";
    up = "echo nameserver $nameserver | ${pkgs.openresolv}/sbin/resolvconf -m 0 -a $dev";
    down = "${pkgs.openresolv}/sbin/resolvconf -d $dev";
  };

  virtualisation.libvirtd.enable = true;

  security.sudo.extraConfig = ''
    %wheel	ALL=(root)	NOPASSWD: ${pkgs.systemd}/bin/systemctl * openvpn-moo
  '';

  home-manager.users.cmacrae = {
    programs.chromium = {
      enable = true;
      extensions = [
        "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
        "naepdomgkenhinolocfifgehidddafch" # browser-pass
      ];
    };

    xdg.configFile."chromium-flags.conf".text = ''
      --force-device-scale-factor=1
    '';
  };

  system.stateVersion = "19.09";
}
