# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, ... }:

let

  globalSettings = {
    email = "evertedsphere@gmail.com";
    username = "evertedsphere";
    systemUsername = "rlptgod";
  };

  pinned = {
    nixpkgs = let
      channelRelease = "nixos-20.09pre218613.ae6bdcc5358";
      channelName = "unstable";
      sha256 = "1aw77y31kh6ippjks5qzz5kqkz6pm5flnhjbp5k598m2pf86id9k";

      url =
        "https://releases.nixos.org/nixos/${channelName}/${channelRelease}/nixexprs.tar.xz";
    in builtins.fetchTarball { inherit url sha256; };

    home-manager = let
      commitHash = "dd93c30";
      sha256 = "0cq6ngagx68rb8w9cyimrl17khr0317m6mazx7fkvqay9qp1pd3y";

      url =
        "https://github.com/rycee/home-manager/archive/${commitHash}.tar.gz";
      home-manager = builtins.fetchTarball { inherit url sha256; };
    in (import home-manager { });
  };

in rec {

  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    pinned.home-manager.nixos
  ];

  nixpkgs.pkgs =
    import "${pinned.nixpkgs}" { inherit (config.nixpkgs) config; };
  nixpkgs.config.allowUnfree = true;

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

  networking.hostName = "zzz";
  networking.hostId = "1337babe"; # haHAA
  networking.networkmanager.enable = true;

  networking.useDHCP = false;
  networking.interfaces.enp9s0.useDHCP = true;
  networking.interfaces.wlp8s0.useDHCP = true;

  # Select internationalisation properties.
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  environment.pathsToLink = [ "/share/zsh" ];
  environment.systemPackages = [ ];

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = true;
  };

  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "ctrl:nocaps";
    libinput.enable = true;
    displayManager.startx.enable = true;
  };

  users.users."${globalSettings.systemUsername}" = {
    uid = 1337;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
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
          iosevka
          mononoki
          ormolu
          discord
          pavucontrol
          nodejs
          dconf
          pinentry
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
          font.name = "Mononoki";
          settings = { font_size = "16.0"; };
        };
        neovim = {
          enable = true;
          extraConfig = builtins.readFile ./nvim/custom.vim;
          plugins = with pkgs.vimPlugins; [
            vim-commentary
            vim-surround
            easymotion
            pathogen

            vim-orgmode
            vim-yaml
            dhall-vim
            idris-vim

            editorconfig-vim
            fzf-vim
            palenight-vim
            coc-nvim
            coc-fzf
            coc-prettier
            coc-yaml
          ];
        };
        command-not-found = { enable = true; };

        password-store = { enable = true; };

        readline = { enable = true; };
        rofi = { enable = true; };
        mpv = { enable = true; };
        starship = { enable = true; };

        keychain = {
          enable = true;
          enableXsessionIntegration = true;
          keys = [ ];
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
          enableCompletion = true;
          enableAutosuggestions = true;
          autocd = true;
          history.save = 100000;
          history.size = 100000;
        };
      };

      services = {
        gpg-agent = {
          enable = true;
          enableSshSupport = true;
        };
      };

      xsession = {
        numlock.enable = true;
        enable = true;
        pointerCursor = {
          package = pkgs.xorg.xcursorthemes;
          name = "whiteglass";
        };
        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
          config = ./xmonad/xmonad.hs;
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

