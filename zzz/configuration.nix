# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, ... }:

let

  settings = {
    email = "evertedsphere@gmail.com";
    username = "evertedsphere";
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

  nix.nixPath = [ "nixpkgs=${pinned.nixpkgs}" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
  environment.systemPackages = with nixpkgs.pkgs; [ ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "ctrl:nocaps";
    libinput.enable = true;
    displayManager.startx.enable = true;
  };

  users.users.rlptgod = {
    uid = 1337;
    isNormalUser = true;
    extraGroups = [ "wheel" ];

  };

  home-manager = {
    useUserPackages = false;
    useGlobalPkgs = true;
    users.rlptgod = { pkgs, ... }: {
      home = {
        packages = with pkgs; [
          nixops
          wget
          curl
          htop
          git
          gitAndTools.git-crypt
          nixfmt
	  iosevka
        ];

        sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };
      };

      manual.html.enable = true;

      news.display = "show";

      programs = {
        browserpass.enable = true;
        direnv.enable = true;
        feh.enable = true;
        firefox.enable = true;
        kitty = {
          enable = true;
          font.name = "Iosevka";
	  settings = {
	    font_size = "16.0";
	  };
        };
	neovim = {
	  enable=true;
	};

	password-store = {
	  enable = true;
	};
	
	readline={enable=true;};
	rofi={
	enable=true;
	};
	mpv = {
	  enable=true;
	};
	starship={enable=true;};

        keychain = {
          enable = true;
          enableXsessionIntegration = true;
          keys = [ ];
        };

        beets = { enable = true; };

        fzf = { enable = true; };

        git = {
          enable = true;
          userEmail = settings.email;
          userName = settings.username;
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

      xsession = {
        enable = true;
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

