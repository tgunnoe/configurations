{ config, pkgs, options, ... }:
let
  home-manager = builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-20.03.tar.gz;
  #feature/gfx-u-boot branch, before linux 5.8 commit
  pinebook-pro = builtins.fetchTarball https://github.com/colemickens/wip-pinebook-pro/archive/17517bc39e2fc27287948c1142ff0f7a6fb87821.tar.gz;
  # latest hydra builds from mobile-nixos project
  mobile-nixpkgs-unstable = builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/24c9b05ac53e422f1af81a156f1fd58499eb27fb.tar.gz;
in
{
  nix.nixPath = [
    # Needed if cache hasnt been built yet, otherwise use latest build from mobile-nixos
    "nixpkgs=${mobile-nixpkgs-unstable}"
    "nixos-config=${builtins.getEnv ("HOME")}/src/configurations/machines/pinebook-pro/configuration.nix"
    #"nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    #"nixos-config=${builtins.getEnv ("HOME")}/src/configurations/machines/pinebook-pro/configuration.nix:/nix/var/nix/profiles/per-user/root/channels"

  ];

  imports = [
    "${home-manager}/nixos"
    "${pinebook-pro}/pinebook_pro.nix"
    ../../modules/home.nix
    ../../modules/desktop.nix
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_pinebookpro_latest;
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
  console = {
    keyMap = "dvorak";
    earlySetup = true;
  };
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.zfsSupport = true;
  # boot.loader.grub.copyKernels = true;
  # boot.loader.grub.device = "nodev";
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.initrd.checkJournalingFS = false;
  # boot.supportedFilesystems = [ "zfs" ];

  hardware = {
    sensor.iio.enable = true;
    bluetooth = {
      enable = true;
    };
  };

  powerManagement.enable = true;
  #services.tlp.enable = true;

  services.logind.extraConfig = "HandlePowerKey=ignore";

  sound.extraConfig = ''
state.rockchipes8316c {
	control.1 {
		iface CARD
		name 'Headphones Jack'
		value false
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
	control.2 {
		iface MIXER
		name 'Headphone Playback Volume'
		value.0 2
		value.1 2
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 3'
			dbmin -4800
			dbmax 0
			dbvalue.0 -1200
			dbvalue.1 -1200
		}
	}
	control.3 {
		iface MIXER
		name 'Headphone Mixer Volume'
		value.0 11
		value.1 11
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 11'
			dbmin -1200
			dbmax 0
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.4 {
		iface MIXER
		name 'Playback Polarity'
		value 'R Invert'
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 Normal
			item.1 'R Invert'
			item.2 'L Invert'
			item.3 'L + R Invert'
		}
	}
	control.5 {
		iface MIXER
		name 'DAC Playback Volume'
		value.0 192
		value.1 192
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 192'
			dbmin -9999999
			dbmax 0
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.6 {
		iface MIXER
		name 'DAC Soft Ramp Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.7 {
		iface MIXER
		name 'DAC Soft Ramp Rate'
		value 4
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 4'
		}
	}
	control.8 {
		iface MIXER
		name 'DAC Notch Filter Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.9 {
		iface MIXER
		name 'DAC Double Fs Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.10 {
		iface MIXER
		name 'DAC Stereo Enhancement'
		value 5
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 7'
		}
	}
	control.11 {
		iface MIXER
		name 'DAC Mono Mix Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.12 {
		iface MIXER
		name 'Capture Polarity'
		value Normal
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 Normal
			item.1 Invert
		}
	}
	control.13 {
		iface MIXER
		name 'Mic Boost Switch'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.14 {
		iface MIXER
		name 'ADC Capture Volume'
		value 192
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 192'
			dbmin -9999999
			dbmax 0
			dbvalue.0 0
		}
	}
	control.15 {
		iface MIXER
		name 'ADC PGA Gain Volume'
		value 0
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 10'
		}
	}
	control.16 {
		iface MIXER
		name 'ADC Soft Ramp Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.17 {
		iface MIXER
		name 'ADC Double Fs Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.18 {
		iface MIXER
		name 'ALC Capture Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.19 {
		iface MIXER
		name 'ALC Capture Max Volume'
		value 28
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 28'
			dbmin -650
			dbmax 3550
			dbvalue.0 3550
		}
	}
	control.20 {
		iface MIXER
		name 'ALC Capture Min Volume'
		value 0
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 28'
			dbmin -1200
			dbmax 3000
			dbvalue.0 -1200
		}
	}
	control.21 {
		iface MIXER
		name 'ALC Capture Target Volume'
		value 11
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 10'
			dbmin -1650
			dbmax -150
			dbvalue.0 0
		}
	}
	control.22 {
		iface MIXER
		name 'ALC Capture Hold Time'
		value 0
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 10'
		}
	}
	control.23 {
		iface MIXER
		name 'ALC Capture Decay Time'
		value 3
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 10'
		}
	}
	control.24 {
		iface MIXER
		name 'ALC Capture Attack Time'
		value 2
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 10'
		}
	}
	control.25 {
		iface MIXER
		name 'ALC Capture Noise Gate Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.26 {
		iface MIXER
		name 'ALC Capture Noise Gate Threshold'
		value 0
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 31'
		}
	}
	control.27 {
		iface MIXER
		name 'ALC Capture Noise Gate Type'
		value 'Constant PGA Gain'
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 'Constant PGA Gain'
			item.1 'Mute ADC Output'
		}
	}
	control.28 {
		iface MIXER
		name 'Speaker Switch'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.29 {
		iface MIXER
		name 'Differential Mux'
		value lin1-rin1
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 lin1-rin1
			item.1 lin2-rin2
			item.2 'lin1-rin1 with 20db Boost'
			item.3 'lin2-rin2 with 20db Boost'
		}
	}
	control.30 {
		iface MIXER
		name 'Digital Mic Mux'
		value 'dmic disable'
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 'dmic disable'
			item.1 'dmic data at high level'
			item.2 'dmic data at low level'
		}
	}
	control.31 {
		iface MIXER
		name 'DAC Source Mux'
		value 'LDATA TO LDAC, RDATA TO RDAC'
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 'LDATA TO LDAC, RDATA TO RDAC'
			item.1 'LDATA TO LDAC, LDATA TO RDAC'
			item.2 'RDATA TO LDAC, RDATA TO RDAC'
			item.3 'RDATA TO LDAC, LDATA TO RDAC'
		}
	}
	control.32 {
		iface MIXER
		name 'Left Headphone Mux'
		value lin1-rin1
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 lin1-rin1
			item.1 lin2-rin2
			item.2 'lin-rin with Boost'
			item.3 'lin-rin with Boost and PGA'
		}
	}
	control.33 {
		iface MIXER
		name 'Right Headphone Mux'
		value lin1-rin1
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 lin1-rin1
			item.1 lin2-rin2
			item.2 'lin-rin with Boost'
			item.3 'lin-rin with Boost and PGA'
		}
	}
	control.34 {
		iface MIXER
		name 'Left Headphone Mixer LLIN Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.35 {
		iface MIXER
		name 'Left Headphone Mixer Left DAC Switch'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.36 {
		iface MIXER
		name 'Right Headphone Mixer RLIN Switch'
		value false
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.37 {
		iface MIXER
		name 'Right Headphone Mixer Right DAC Switch'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
}

      '';


  networking = {
    hostId = "b16be668";
    hostName = "gammu";
    networkmanager.enable = true;
  };

  local = {
    home.git.userEmail = "t@gvno.net";

    desktop = {
      extraPkgs = with pkgs; [
        libinput
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
            accel_profile = "adaptive";
            pointer_accel = "0.6";
            drag = "enabled";
            tap = "enabled";
            dwt = "enabled";
            natural_scroll = "disabled";
            middle_emulation = "enabled";
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
#     anbox = {
#       enable = true;
#     };
    docker = {
      autoPrune.enable = true;
      enable = true;
    };
  };

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
  environment.variables = {
    PAN_MESA_DEBUG = "gles3";
  };
  system.stateVersion = "20.03";
}
