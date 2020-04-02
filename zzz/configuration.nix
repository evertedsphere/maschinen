{ config, ... }:

let

  globalSettings = {
    email = "evertedsphere@gmail.com";
    username = "evertedsphere";
    systemUsername = "rlptgod";
  };

  pinned = import ./pinned.nix;
  pkgs0 = pinned.nixpkgs;

in rec {

  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    pinned.home-manager.nixos
  ];

  nixpkgs = {
    pkgs = import pinned.nixpkgs { inherit (config.nixpkgs) config; };

    config.allowUnfree = true;
    config.packageOverrides = pkgs: {
      nur = import pinned.nix-user-repository { inherit (pinned.nixpkgs) ; };
    };
  };

  nix.nixPath = [ "nixpkgs=${pinned.nixpkgs}" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ZFS/filesystem configuration
  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.zfs.enableUnstable = true;
  services.zfs.autoScrub = { enable = true; };
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

  environment.systemPackages = [ ];
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
      layout = "us";
      xkbOptions = "ctrl:nocaps";
      libinput.enable = true;

      desktopManager.xterm.enable = true;
      displayManager.lightdm.enable = true;
      windowManager.session = [{
        name = "dummy";
        start = "${nixpkgs.pkgs.coreutils}/bin/true";
      }];
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users."${globalSettings.systemUsername}" = {
    uid = 1337;
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "systemd-journal" ];
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
          ripgrep
          iosevka
          mononoki
          ormolu
          discord
          pavucontrol
          nodejs
          pywal
          dconf
          pinentry
          glances
          stress
          gnome3.nautilus
          ffmpegthumbnailer
          shotwell
          docker-compose
          hydron
          python3
          python2
          qbittorrent

          xclip
          xdg_utils
        ];

        file.".xinitrc".source = ./.xinitrc;
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
          package = pkgs.papirus-icon-theme;
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
            background_opacity = "0.80";
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
          highlightBaseName = true;
          showProgramPath = false;
          treeView = true;
        };

        zsh = {
          enable = true;
          oh-my-zsh = {
            enable = true;
            plugins = [ "sudo" ];
            theme = "agnoster";
          };
          # enableCompletion = true;
          # enableAutosuggestions = true;
          # autocd = true;
          history.save = 100000;
          history.size = 100000;
          initExtra = builtins.readFile ~/.cache/wal/colors.sh;
        };

      };

      services = {
        udiskie.enable = true;

        # taffybar = {
        #   enable = true;
        #   package = (import ./taffybar { inherit nixpkgs.pkgs; }).evsphbar;
        # };

        picom = {
          enable = true;
          backend = "glx";
          experimentalBackends = true;
          extraOptions = ''
            blur: 
            {
              method = "gaussian";
              size = 12;
              deviation = 7.0;
            };
            shadow-radius: 15;
          '';
          fade = true;
          vSync = true;
          shadow = true;
          shadowOpacity = "1.0";
          shadowOffsets = [ (-15) (-15) ];
          fadeDelta = 3;
          fadeSteps = [ "0.04" "0.04" ];
          # inactiveDim = "0.20";
        };
      };

      xsession = {
        numlock.enable = true;
        enable = true;
        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
          haskellPackages = pkgs.haskellPackages.override {
            overrides = hnew: hold: {
              evsph-xmonad = hnew.callPackage ./xmonad { };
            };
          };
          extraPackages = hp: [ hp.evsph-xmonad ];
          config = pkgs.writeText "xmonad.hs" ''
            import XMonad (xmonad)
            import EvsphXMonad
            main = do
              xmonad evsphDefaults
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

