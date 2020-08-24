{ config, lib, pkgs, ... }:

let
  cfg = config.local.home;

  # kubeTmux = pkgs.fetchFromGitHub {
  #   owner = "jonmosco";
  #   repo = "kube-tmux";
  #   rev = "7f196eeda5f42b6061673825a66e845f78d2449c";
  #   sha256 = "1dvyb03q2g250m0bc8d2621xfnbl18ifvgmvf95nybbwyj2g09cm";
  # };

  # tmuxYank = pkgs.fetchFromGitHub {
  #   owner = "tmux-plugins";
  #   repo = "tmux-yank";
  #   rev = "ce21dafd9a016ef3ed4ba3988112bcf33497fc83";
  #   sha256 = "04ldklkmc75azs6lzxfivl7qs34041d63fan6yindj936r4kqcsp";
  # };
  nurNoPkgs = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz")  { };
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz)
    # reuse the current configuration
    { config = config.nixpkgs.config; };

in with pkgs.stdenv; with lib; {
  options.local.home = with types; {
    # alacritty.bindings = mkOption {
    #   type = listOf attrs;
    #   default = [{}];
    #   description = "Keybindings for Alacritty.";
    # };

    # alacritty.fontSize = mkOption {
    #   type = int;
    #   default = 12;
    #   description = "Font size for Alacritty.";
    # };

    git.userName = mkOption {
      type = str;
      default = "tgunnoe";
      description = "Username for Git";
    };

    git.userEmail = mkOption {
      type = str;
      default = "t@gvno.net";
      description = "User e-mail for Git";
    };
  };

  config = {
    time.timeZone = "America/New_York";
    nix.trustedUsers = [ "root" "tgunnoe" ];
    nixpkgs.config.allowUnfree = true;
    nix = {
     package = pkgs.nixUnstable;
     extraOptions = ''
       experimental-features = nix-command flakes
     '';
    };
    # nix.extraOptions = ''
    #   plugin-files = ${pkgs.nix-plugins.override {
    #            nix = config.nix.package; }}/lib/nix/plugins/libnix-extra-builtins.so
    # '';

    nixpkgs.config.packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };

    environment.systemPackages = [ pkgs.zsh ];
    users.users.tgunnoe.shell = pkgs.zsh;
    users.users.tgunnoe.home = "/home/tgunnoe";

    home-manager.users.tgunnoe = mkMerge [
      {
        imports = [ nurNoPkgs.repos.rycee.hmModules.emacs-init ];

        home.packages = import ./packages.nix { inherit pkgs unstable; };

        home.sessionVariables = {
          PAGER = "less -R";
          EDITOR = "emacsclient";
        };

        programs = {
          emacs = {
	          enable = true;
	          package = pkgs.emacs;
            init = import ./emacs-init.nix {inherit pkgs;};
          };
          git = {
            enable = true;
            userName = cfg.git.userName;
            userEmail = cfg.git.userEmail;
          };
          firefox = {
            enable = true;
            extensions =
              with pkgs.nur.repos.rycee.firefox-addons; [
                ublock-origin
                browserpass
                umatrix
                https-everywhere
              ];
            #package = pkgs.firefox-wayland;
            profiles =
              let defaultSettings = {
                    "app.update.auto" = false;
                    "browser.startup.homepage" = "https://duckduckgo.com";
                    "browser.search.region" = "US";
                    "browser.search.countryCode" = "US";
                    "browser.search.isUS" = true;
                    "browser.ctrlTab.recentlyUsedOrder" = false;
                    "browser.newtabpage.enabled" = false;
                    "browser.bookmarks.showMobileBookmarks" = true;
                    "distribution.searchplugins.defaultLocale" = "en-US";
                    "general.useragent.locale" = "en-US";
                    "identity.fxaccounts.account.device.name" = config.networking.hostName;
                    "privacy.trackingprotection.enabled" = true;
                    "privacy.trackingprotection.socialtracking.enabled" = true;
                    "privacy.trackingprotection.socialtracking.annotate.enabled" = true;
                    "services.sync.declinedEngines" = "addons,passwords,prefs";
                    "services.sync.engine.addons" = false;
                    "services.sync.engineStatusChanged.addons" = true;
                    "services.sync.engine.passwords" = false;
                    "services.sync.engine.prefs" = false;
                    "services.sync.engineStatusChanged.prefs" = true;
                    "signon.rememberSignons" = false;
                  };
              in {
                home = {
                  id = 0;
                  settings = defaultSettings // {
                    "browser.urlbar.placeholderName" = "DuckDuckGo";
                  };
                };

                work = {
                  id = 1;
                  settings = defaultSettings // {
                    "browser.startup.homepage" = "about:blank";
                  };
                };
              };
          }; # /firefox

          fzf = {
            enable = true;
            enableZshIntegration = true;
          };
          browserpass = {
            enable = true;
            browsers = [ "chrome" "chromium" "firefox" ];
          };
          termite = {
            enable = true;
            backgroundColor = "rgba(0, 0, 0, 0.6)";
            clickableUrl = true;
            font = "Ubuntu Mono 12";
            allowBold = true;
            fullscreen = true;

          };
          zsh = {
            enable = true;
            enableAutosuggestions = true;
            enableCompletion = true;
            defaultKeymap = "emacs";
            initExtra = "source ${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k.zsh-theme";
            sessionVariables = { RPROMPT = ""; };

            shellAliases = {
              # k = "kubectl";
              # kp = "kube-prompt";
              # kc = "kubectx";
              # kn = "kubens";
              t = "cd $(mktemp -d)";
            };

            oh-my-zsh.enable = true;

            plugins = [
              {
                name = "autopair";
                file = "autopair.zsh";
                src = pkgs.fetchFromGitHub {
                  owner = "hlissner";
                  repo = "zsh-autopair";
                  rev = "4039bf142ac6d264decc1eb7937a11b292e65e24";
                  sha256 = "02pf87aiyglwwg7asm8mnbf9b2bcm82pyi1cj50yj74z4kwil6d1";
                };
              }
              {
                name = "fast-syntax-highlighting";
                file = "fast-syntax-highlighting.plugin.zsh";
                src = pkgs.fetchFromGitHub {
                  owner = "zdharma";
                  repo = "fast-syntax-highlighting";
                  rev = "v1.28";
                  sha256 = "106s7k9n7ssmgybh0kvdb8359f3rz60gfvxjxnxb4fg5gf1fs088";
                };
              }
              {
                name = "pi-theme";
                file = "pi.zsh-theme";
                src = pkgs.fetchFromGitHub {
                  owner = "tobyjamesthomas";
                  repo = "pi";
                  rev = "96778f903b79212ac87f706cfc345dd07ea8dc85";
                  sha256 = "0zjj1pihql5cydj1fiyjlm3163s9zdc63rzypkzmidv88c2kjr1z";
                };
              }
              {
                name = "z";
                file = "zsh-z.plugin.zsh";
                src = pkgs.fetchFromGitHub {
                  owner = "agkozak";
                  repo = "zsh-z";
                  rev = "41439755cf06f35e8bee8dffe04f728384905077";
                  sha256 = "1dzxbcif9q5m5zx3gvrhrfmkxspzf7b81k837gdb93c4aasgh6x6";
                };
              }
            ];
          }; # /zsh
          tmux = {
            enable = true;
            shortcut = "q";
            keyMode = "emacs";
            clock24 = true;
            terminal = "screen-256color";
            customPaneNavigationAndResize = true;
            secureSocket = false;
            extraConfig = ''
            unbind [
            unbind ]

            bind ] next-window
            bind [ previous-window

            bind Escape copy-mode
            bind P paste-buffer
            bind-key -T copy-mode-vi v send-keys -X begin-selection
            bind-key -T copy-mode-vi y send-keys -X copy-selection
            bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
            set -g mouse on

            bind-key -r C-k resize-pane -U
            bind-key -r C-j resize-pane -D
            bind-key -r C-h resize-pane -L
            bind-key -r C-l resize-pane -R

            bind-key -r C-M-k resize-pane -U 5
            bind-key -r C-M-j resize-pane -D 5
            bind-key -r C-M-h resize-pane -L 5
            bind-key -r C-M-l resize-pane -R 5

            set -g display-panes-colour white
            set -g display-panes-active-colour red
            set -g display-panes-time 1000
            set -g status-justify left
            set -g set-titles on
            set -g set-titles-string 'tmux: #T'
            set -g repeat-time 100
            set -g renumber-windows on
            set -g renumber-windows on

            setw -g monitor-activity on
            setw -g automatic-rename on
            setw -g clock-mode-colour red
            setw -g clock-mode-style 24
            setw -g alternate-screen on

            set -g status-left-length 100

            set -g status-right-length 100
            set -g status-right "#[fg=red,bg=default] %b %d #[fg=blue,bg=default] %R "
            set -g status-bg default
            setw -g window-status-format "#[fg=blue,bg=black] #I #[fg=blue,bg=black] #W "
            setw -g window-status-current-format "#[fg=blue,bg=default] #I #[fg=red,bg=default] #W "

          '';
          };
        }; # /programs

        # programs.alacritty = {
        #   enable = true;
        #   settings = mkMerge [
        #     {
        #       window.padding.x = 15;
        #       window.padding.y = 15;
        #       window.decorations =
        #         if isDarwin
        #         then "buttonless"
        #         else "none";
        #       scrolling.history = 100000;
        #       live_config_reload = true;
        #       selection.save_to_clipboard = true;
        #       dynamic_title = false;
        #       mouse.hide_when_typing = true;

        #       font = {
        #         normal.family =
        #           if isDarwin
        #           then "Menlo"
        #           else "DejaVu Sans Mono";
        #         size = cfg.alacritty.fontSize;
        #       };

        #       colors = {
        #         primary.background = "0x282c34";
        #         primary.foreground = "0xabb2bf";

        #         normal = {
        #           black = "0x282c34";
        #           red = "0xe06c75";
        #           green = "0x98c379";
        #           yellow = "0xd19a66";
        #           blue = "0x61afef";
        #           magenta = "0xc678dd";
        #           cyan = "0x56b6c2";
        #           white = "0xabb2bf";
        #         };

        #         bright = {
        #           black = "0x5c6370";
        #           red = "0xe06c75";
        #           green = "0x98c379";
        #           yellow = "0xd19a66";
        #           blue = "0x61afef";
        #           magenta = "0xc678dd";
        #           cyan = "0x56b6c2";
        #           white = "0xffffff";
        #         };
        #       };
        #     }

        #     (mkIf (cfg.alacritty.bindings != [{}])
        #       { key_bindings = cfg.alacritty.bindings; }
        #     )
        #   ];
        # } ;

        # programs.
      }


      { services.emacs.enable =  true; }

    ];
  };
}
