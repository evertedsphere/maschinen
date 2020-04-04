{ config, ... }:

let
  globalSettings = {
    email = "evertedsphere@gmail.com";
    username = "evertedsphere";
    systemUsername = "rlptgod";
  };
  systemConstants = {
    zfs_arc_min = 2147483648;
    zfs_arc_max = 4294967296;
  };

  pinned = import ./pinned.nix;

in rec {

  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    pinned.home-manager.nixos
  ];

  nixpkgs = {
    pkgs = import pinned.nixpkgs { inherit (config.nixpkgs) config; };

    config.allowUnfree = true;
    config.packageOverrides = pkgs: {
      # nur = import pinned.nix-user-repository { inherit (pinned.nixpkgs) ; };
      picom-ibhagwan = pkgs.callPackage ./picom-ibhagwan.nix { };
      nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload"  ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only

        exec -a "$0" "$@"
      '';
    };
  };

  nix.nixPath = [ "nixpkgs=${pinned.nixpkgs}" ];
  boot.kernelPackages = nixpkgs.pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "elevator=cfq"
    "cgroup_enable=memory"
    "swapaccount=1"
    "zfs.zfs_arc_min=${builtins.toString systemConstants.zfs_arc_min}"
    "zfs.zfs_arc_max=${builtins.toString systemConstants.zfs_arc_max}"
  ];
  # boot.extraModprobeConfig = ''
  #   options zfs zfs_arc_min=${builtins.toString systemConstants.zfs_arc_min}
  #   options zfs zfs_arc_max=${builtins.toString systemConstants.zfs_arc_max}
  # '';
    # options zfs_vdev_cache_bshift=18
    # options l2arc_feed_again=0
    # options zfs zfs_compressed_arc_enable=1
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ZFS/filesystem configuration
  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.blacklistedKernelModules = [ "i915" ];
  boot.zfs.enableUnstable = true;
  boot.zfs.forceImportRoot = false;
  boot.zfs.forceImportAll = false;
  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "daily";
    };
    trim = {
      enable = true;
      interval = "daily";
    };
    autoSnapshot = {
      enable = true;
      frequent = 8;
    };
  };
  fileSystems."/home".neededForBoot = true;

  networking = {
    hostName = "zzz";
    hostId = "1337babe"; # haHAA
    networkmanager.enable = true;

    useDHCP = false;
    interfaces.enp9s0.useDHCP = true;
    interfaces.wlp8s0.useDHCP = true;

    firewall.allowedTCPPorts = [ 19999 24272 ];
    firewall.allowedUDPPorts = [ 24272 ];
  };

  # Select internationalisation properties.
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  environment.systemPackages = [ ]; #nixpkgs.pkgs.nvidia-offload ];
  environment.pathsToLink = [ "/share/zsh" ];

  virtualisation.docker = { enable = true; };

  services = {
    openssh = {
      enable = true;
      permitRootLogin = "yes";
      passwordAuthentication = true;
    };

    netdata = { enable = true; };

    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      layout = "us";
      xkbOptions = "ctrl:nocaps";
      dpi = 96;
      libinput.enable = true;

      desktopManager.xterm.enable = true;
      displayManager.lightdm.enable = true;
      windowManager.session = [{
        name = "dummy";
        start = "${nixpkgs.pkgs.coreutils}/bin/true";
      }];
    };

    gnome3.at-spi2-core.enable = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    s3tcSupport = true;
    extraPackages = with nixpkgs.pkgs; [
      libvdpau-va-gl
      vaapiVdpau
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    prime = {
      sync.enable = true;
      # offload.enable = true;
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users."${globalSettings.systemUsername}" = {
    uid = 1337;
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "systemd-journal" "audio" ];
    shell = "/home/${globalSettings.systemUsername}/.nix-profile/bin/zsh";
  };

  home-manager = {
    useUserPackages = false;
    useGlobalPkgs = true;
    users."${globalSettings.systemUsername}" = { pkgs, ... }: {
      home = {
        extraOutputsToInstall = [ "doc" "info" "devdoc" ];
        username = globalSettings.systemUsername;

        packages = with pkgs; [
          nixops
          next
          fd
          wget
          curl
          htop
          gitAndTools.git-crypt
          nixfmt
          ncmpcpp
          i3lock
          ripgrep
          iosevka
          neofetch
          mononoki
          ormolu
          discord
          pavucontrol
          nodejs
          pywal
          wpgtk
          dconf
          pinentry
          glances
          stress
          gnome3.nautilus
          ffmpegthumbnailer
          hicolor-icon-theme
          shotwell
          docker-compose
          hydron
          python3
          python2
          qbittorrent

          xclip
          xdg_utils
          ncmpc
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
      manual.html.enable = true;
      manual.manpages.enable = true;
      manual.json.enable = true;

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
            font_size = "14.0";
            background_opacity = "0.75";
          };

          extraConfig = "include ~/.cache/wal/colors-kitty.conf";
        };

        neovim = {
          enable = true;
          extraConfig = builtins.readFile ./nvim/custom.vim;
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
            coc-yaml
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
            right = [];
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

        screen-locker = {
          enable = true;
          inactiveInterval = 1;
          lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 000000";
        };

        mpd = {
          enable = true;
          extraConfig = builtins.readFile ./mpd.conf;
        };

        polybar = {
          enable = true;
          extraConfig = builtins.readFile ./polybar.conf;
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

        # taffybar = {
        #   enable = true;
        #   # package = (import ./taffybar { inherit nixpkgs.pkgs; }).evsphbar;
        # };

        picom = {
          enable = true;
          package = pkgs.picom-ibhagwan;
          backend = "glx";
          experimentalBackends = true;
          extraOptions = ''
            blur: {
              method = "dual_kawase";
              strength = 6;
              background = false;
              background-frame = false;
              background-fixed = false;
            }
            shadow-radius: 15;
            # corner-radius: 10.0;
          '';
          fade = true;
          vSync = true;

          shadow = true;
          shadowOpacity = "0.6";
          noDNDShadow = true;
          noDockShadow = false;
          shadowOffsets = [ (-20) (-20) ];

          fadeDelta = 3;
          fadeSteps = [ "0.04" "0.04" ];
          # inactiveDim = "0.20";
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
              evsph-xmonad = hnew.callPackage ./xmonad { };
            };
          };
          extraPackages = hp: [ hp.evsph-xmonad hp.taffybar ];
          config = pkgs.writeText "xmonad.hs" ''
            module Main where

            import XMonad
            import XMonad.Hooks.EwmhDesktops (ewmh)
            import XMonad.Hooks.ManageDocks
            import System.Taffybar.Support.PagerHints (pagerHints)

            import EvsphXMonad

            main 
              = xmonad 
              $ docks 
              $ ewmh 
              $ pagerHints evsphDefaults
          '';
        };
      };
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

