{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.local.desktop;

  # NOTE
  # - $SWAYSOCK unavailable
  # - $(sway --get-socketpath) doesn't work
  # A bit hacky, but since we always know our uid
  # this works consistently
  reloadSway = ''
    echo "Reloading sway"
    swaymsg -s \
    $(find /run/user/''${UID}/ \
      -name "sway-ipc.''${UID}.*.sock") \
    reload
  '';

  local.lib = (import ../lib/generators.nix { inherit lib; });

in with local.lib; {
  imports = [ ./home.nix ];

  options.local.desktop = {
    extraPkgs = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Extra packages to install.";
    };

    sway = {
      inputs = mkOption {
        type = types.attrs;
        default = {};
        description = "Input device configuration for Sway.";
      };
      outputs = mkOption {
        type = types.listOf types.attrs;
        default = [{}];
        description = "Display output configuration for Sway.";
      };
      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = "Extra arbitrary configuration for Sway.";
      };
    };
  };

  config = {
    sound = {
      enable = true;
      extraConfig = ''
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
    };

    hardware.pulseaudio.enable = true;
    hardware.pulseaudio.package = pkgs.pulseaudioFull;

    environment.systemPackages = with pkgs; [ file  ];
    fonts = {
      enableDefaultFonts = true;
      fonts = with pkgs; [
        corefonts
        dejavu_fonts
        inconsolata
        #nerdfonts
        powerline-fonts
        roboto
        roboto-mono
        roboto-slab
        ubuntu_font_family
        emacs-all-the-icons-fonts
      ];
    };

    #services.illum.enable = true;

    services.openssh.enable = true;

    services.tor = {
      enable = true;
      client.enable = true;
    };

    security.sudo.enable = true;
    security.rtkit.enable = true;


    users.users.tgunnoe = {
      description = "Taylor Gunnoe";
      isNormalUser = true;
      uid = 1000;
      extraGroups = [
        "adbusers"
        "audio"
        "cdrom"
        "docker"
        "input"
        "libvirtd"
        "networkmanager"
        "plugdev"
        "sway"
        "tty"
        "video"
        "wheel"
      ];
    };
    programs.light.enable = true;
    programs.sway = {
      enable = true;
      extraPackages = []; # handled via home-manager
      extraSessionCommands =
        ''
        export SDL_VIDEODRIVER=wayland
        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland-egl
        export QT_WAYLAND_FORCE_DPI=physical
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
        '';
    };

    home-manager.users.tgunnoe = {
      home.packages = with pkgs; [
        swayidle # idle handling
        swaylock # screen locking
        waybar   # polybar-alike
        grim     # screen image capture
        slurp    # screen are selection tool
        mako     # notification daemon
        kanshi   # dynamic display configuration helper
        #imv      # image viewer
        wf-recorder # screen recorder
        wl-clipboard  # wayland vers of xclip

        xdg_utils     # for xdg_open
        xwayland      # for X apps
        libnl         # waybar wifi
        libpulseaudio # waybar audio

        #spotify

        swaybg   # required by sway for controlling desktop wallpaper
        clipman
        i3status-rust # simpler bar written in Rust
        drm_info
        gebaar-libinput  # libinput gestures utility
        #glpaper          # GL shaders as wallpaper
        #>oguri            # animated background utility
        #redshift-wayland # patched to work with wayland gamma protocol
        #rootbar
        swaylock-fancy
        waypipe          # network transparency for Wayland
        wdisplays
        wlr-randr
        #wlay
        wofi
        #wtype            # xdotool, but for wayland
        #wlogout
        #wldash

        # TODO: more steps required to use this?
        #xdg-desktop-portal-wlr # xdg-desktop-portal backend for wlroots
      ] ++ cfg.extraPkgs;

      home.sessionVariables = {
        GDK_SCALE = "-1";
        GDK_BACKEND = "wayland"; #needs to be x11 for electron apps
      };

      xdg.enable = true;
      xdg.configFile."sway/config" = {
          source = pkgs.substituteAll {
            name = "sway-config";
            src = ../conf.d/sway.conf;
            wall = "/home/tgunnoe/src/configurations/conf.d/polyscape-background-15.png";
            inputs = "${toSwayInputs cfg.sway.inputs}";
            extraConfig = "${cfg.sway.extraConfig}";
          };
          onChange = "${reloadSway}";
      };

      xdg.configFile."kanshi/config".text = "${toSwayOutputs cfg.sway.outputs}";

      xdg.configFile."mako/config".text = ''
        font=DejaVu Sans 11
        text-color=#1D2021D9
        background-color=#00000099
        border-color=#0D6678D9
        border-size=3
        max-visible=3
        default-timeout=5000
        progress-color=source #8BA59B00
        group-by=app-name
        sort=-priority

        [urgency=high]
        border-color=#FB543FD9
        ignore-timeout=1
        default-timeout=0
      '';

      xdg.configFile."imv/config".text = ''
        [options]
        background=#1D2021
        overlay_font=DejaVu Sans Mono:14
      '';

      xdg.configFile."waybar/config" = {
        onChange = "${reloadSway}";
        text = builtins.toJSON (
          import ./waybar-config.nix {
            inherit (config.networking) hostName;
            inherit pkgs;
            inherit lib;
          }
        );
      };

      xdg.configFile."waybar/style.css" = {
        text = (builtins.readFile ../conf.d/waybar.css);
        onChange = "${reloadSway}";
      };

      gtk = {
        enable = true;
        font.package = pkgs.dejavu_fonts;
        font.name = "Ubuntu Condensed 12";
        theme.package = pkgs.pantheon.elementary-gtk-theme;
        theme.name = "elementary";
        iconTheme.package = pkgs.pantheon.elementary-icon-theme;
        iconTheme.name = "elementary";
        gtk3 = {
          extraConfig = { gtk-application-prefer-dark-theme = true; };
          extraCss = ''
            .termite {
              padding: 15px;
            }
          '';
        };


      };
      #programs.rofi.enable = true;

      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        extraConfig = ''
          allow-emacs-pinentry
          allow-loopback-pinentry
        '';
      };
    };
  };
}
