{ ... }:

let

  globalSettings = {
    email = "evertedsphere@gmail.com";
    username = "evertedsphere";
    systemUsername = "rlptgod";
  };

in {
  users.users."${globalSettings.systemUsername}" = {
    uid = 1337;
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "systemd-journal" "audio" "input" ];
    # FIXME can we not do this pls. maybe get path from hm
    shell = "/home/${globalSettings.systemUsername}/.nix-profile/bin/zsh";
  };

  home-manager = {
    useUserPackages = false;
    useGlobalPkgs = true;
    users."${globalSettings.systemUsername}" = { pkgs, ... }: {
      home = {
        extraOutputsToInstall = [ "doc" "info" "devdoc" ];
        username = globalSettings.systemUsername;
        file.".maschine.ini".text = ''
          system-config-path = ${pkgs.maschinen-system}
          scripts = ${pkgs.maschinen-scripts}
        '';

        packages = with pkgs; [
          maschinen-system
          maschinen-scripts

          # binutils
          fd
          wget
          curl
          gitAndTools.git-crypt
          neofetch
          gotop
          pciutils
          stress

          # net
          # wavemon
          # kismet

          # media
          imagemagick

          # "system"
          nixops
          htop
          unstable.kmon
          glances
          pinentry
          lm_sensors
          psmisc
          lsof
          firejail
          kmonad

          # programming
          nixfmt
          ormolu
          python2 # for wpg
          # python3
          nodejs
          niv

          # X apps
          next
          i3lock
          gnome3.nautilus
          discord
          xclip
          xdg_utils
          qbittorrent
          flameshot

          # media
          ncmpcpp
          ripgrep
          ffmpegthumbnailer
          pavucontrol
          ncmpc
          shotwell
          scrot

          # fonts
          iosevka
          mononoki

          # theming
          pywal
          wpgtk
          dconf
          hicolor-icon-theme

          # graphics
          glxinfo
          lxappearance

          # social
          tdesktop
          signal-desktop
          signal-cli

          # for the lockscreen
          sox
          font-awesome_5
        ];

        sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };
      };

      xdg = {
        userDirs = {
          enable = true;
          desktop = "desktop";
          documents = "docs";
          download = "down";
          music = "music";
          pictures = "img";
          publicShare = "public";
          videos = "videos";
        };
      };

      manual = {
        html.enable = true;
        manpages.enable = true;
        json.enable = true;
      };

      news.display = "show";

      gtk = {
        enable = true;
        theme = {
          name = "Adapta-Nokto-Eta";
          package = pkgs.adapta-gtk-theme;
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.hicolor-icon-theme;
        };
        gtk2.extraConfig = ''
          gtk-application-prefer-dark-theme = true
        '';
        gtk3.extraConfig = { gtk-application-prefer-dark-theme = true; };
      };

      programs = {
        bat = { enable = true; };
        info = { enable = true; };

        irssi = {
          enable = true;

          networks = {
            freenode = {
              nick = "evertedsphere";
              server = {
                address = "chat.freenode.net";
                port = 6697;
                autoConnect = true;
              };
              channels = {
                nixos.autoJoin = true;
                haskell.autoJoin = true;
              };
            };
          };
        };

        browserpass.enable = true;

        direnv = {
          enable = true;
          enableZshIntegration = true;
        };

        feh.enable = true;

        firefox.enable = true;

        kitty = {
          enable = true;
          font = {
            name = "PragmataPro Mono";
            # package = pkgs.iosevka;
          };

          settings = {
            window_padding_width = 12;
            font_size = "12.0";
            background_opacity = "0.75";
          };

          extraConfig = "include ~/.cache/wal/colors-kitty.conf";
        };

        neovim = {
          enable = true;
          extraConfig = builtins.readFile ./apps/nvim/custom.vim;
          plugins = with pkgs.vimPlugins; [
            # Basics
            vim-commentary
            vim-surround
            easymotion

            # Utils
            pathogen
            fzf-vim
            editorconfig-vim

            # Formats
            vim-orgmode
            vim-yaml
            haskell-vim
            dhall-vim
            idris-vim
            vim-nix

            # UI
            vim-airline
            vim-airline-themes
            wal-vim

            # Completion
            coc-nvim
            coc-fzf
            coc-prettier
            coc-java
            coc-yaml
            coc-snippets
            vim-snippets 
            coc-highlight
            coc-html
            coc-json
            coc-neco
            coc-git
            coc-lists
            coc-yank
            coc-vimtex
            # coc-denite
            # denite
          ];
        };

        command-not-found = { enable = true; };

        password-store = { enable = true; };

        readline = { enable = true; };
        rofi = {
          enable = true;
          theme = "~/.cache/wal/colors-rofi-dark.rasi";
          font = "PragmataPro Mono 20";
        };
        mpv = { enable = true; };

        keychain = {
          enable = true;
          enableXsessionIntegration = true;
          keys = [ "id_rsa" ];
          agents = [ "gpg" "ssh" ];
        };

        beets = { enable = true; };

        fzf = { enable = true; };

        git = {
          enable = true;
          userEmail = globalSettings.email;
          userName = globalSettings.username;
        };

        gpg = { enable = true; };

        jq = { enable = true; };

        htop = {
          enable = true;
          hideThreads = true;
          hideUserlandThreads = true;
          highlightBaseName = true;
          showProgramPath = false;
          treeView = true;
          meters = {
            left = [ "Tasks" "LoadAverage" "Blank" "CPU" "Memory" "Swap" ];
            right = [ ];
          };
        };

        zsh = {
          enable = true;
          oh-my-zsh = {
            enable = true;
            plugins = [ "sudo" ];
            theme = "steeef";
          };
          # enableCompletion = true;
          # enableAutosuggestions = true;
          # autocd = true;
          history.save = 100000;
          history.size = 100000;
          initExtra = ''
            source ~/.cache/wal/colors.sh
          '';
        };

      };

      services = {
        udiskie.enable = true;

        lorri.enable = true;

        redshift = {
          enable = true;
          # provider = "geoclue2";
          latitude = "22.56250000";
          longitude = "88.36277778";
        };

        screen-locker = {
          enable = true;
          inactiveInterval = 5;
          lockCmd = "${pkgs.maschinen-scripts}/glitchlock.sh";
        };

        mpd = {
          enable = true;
          extraConfig = builtins.readFile ./apps/mpd.conf;
        };

        polybar = {
          enable = true;
          extraConfig = import ./apps/polybar.nix { inherit pkgs; };
          package = pkgs.polybar.override { mpdSupport = true; };
          script = ''
            source ~/.cache/wal/colors.sh
            export bg_opacity="bf"
            export border_opacity="22"
            export polybar_background="#''${bg_opacity}''${color0/'#'}"
            export polybar_border="#''${border_opacity}''${color0/'#'}"
            polybar top &
            polybar bottom &
          '';
        };

        picom = let
          shadowRadius = 15;
          shadowOffset = -1 * shadowRadius;
        in {
          enable = true;
          package = pkgs.picom-ibhagwan;
          backend = "glx";
          experimentalBackends = true;
          extraOptions = ''
            blur: {
              method = "dual_kawase";
              strength = 8;
              background = false;
              background-frame = false;
              background-fixed = false;
            }

            shadow-radius: ${builtins.toString shadowRadius};

            # (disabled) slightly rounded corners
            corner-radius: 10.0;
          '';
          fade = true;
          vSync = true;

          shadow = false;
          shadowOpacity = "0.6";
          noDNDShadow = true;
          noDockShadow = false;
          shadowOffsets = [ shadowOffset shadowOffset ];

          fadeDelta = 3;
          fadeSteps = [ "0.04" "0.04" ];
          # inactiveDim = "0.10";
        };
      };

      xsession = {
        numlock.enable = true;
        enable = true;
        initExtra = "wal -R";
        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
          haskellPackages = pkgs.haskellPackages.override {
            overrides = hnew: hold: {
              evsph-xmonad = hnew.callCabal2nix ./apps/xmonad { };
            };
          };
          extraPackages = hp: [ hp.evsph-xmonad ];
          config = pkgs.writeText "xmonad.hs" ''
            module Main where

            import XMonad
            import qualified EvsphXMonad

            main = xmonad EvsphXMonad.customConfig
          '';
        };
      };
    };
  };
}
