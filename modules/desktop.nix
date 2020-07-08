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
        nerdfonts
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
