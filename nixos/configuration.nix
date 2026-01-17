# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, pkgs-unstable, pkgs-24, pkgs-25-05, pkgs-25-11, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
      ./modules/smartcards.nix
    ];

  smartcards.enable = false;

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.configurationLimit = 5;
  boot.loader.grub.useOSProber=true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zagreb";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "hr_HR.UTF-8";
    LC_IDENTIFICATION = "hr_HR.UTF-8";
    LC_MEASUREMENT = "hr_HR.UTF-8";
    LC_MONETARY = "hr_HR.UTF-8";
    LC_NAME = "hr_HR.UTF-8";
    LC_NUMERIC = "hr_HR.UTF-8";
    LC_PAPER = "hr_HR.UTF-8";
    LC_TELEPHONE = "hr_HR.UTF-8";
    LC_TIME = "hr_HR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;

  services.xserver.displayManager.setupCommands = ''
	CENTER='eDP-1'
        UP='HDMI-1'
        ${pkgs.xorg.xrandr}/bin/xrandr --output $UP --up-of $CENTER
       '';
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "hr";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "croat";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;

  ## Na novijim verzijama zamijeniti sa hardware.graphics.enable=true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  security.rtkit.enable = true;
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mmin = {
    isNormalUser = true;
    description = "Marko";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
    packages = with pkgs; [
      pkgs-24.firefox
      thunderbird
      brave
      libreoffice
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "mmin";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Automatic nix store garbage collection
  nix.gc.automatic = true;
  nix.gc.dates = "14days";
  # Delete generations/profiles/everything older than 30 days!
  nix.gc.options = "--delete-older-than 30days";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    home-manager
    pkgs-25-05.neovim
    tmux
    wget
    git
    gcc
    python3
    zsh

    xclip
    tldr
    docker

    pkgs-25-11.erlang_28
    pkgs-25-11.beam.packages.erlang_28.rebar3
    pkgs-unstable.signal-desktop
    vips
    file
    #beam.packages.erlangR26.erlang-ls
    erlang-ls
    lfe
    # make 4.2.1
    gnumake42

    marksman

    feh
    pkgs-24.ngrok

    zig_0_11
    zls

    # Grisp
    picocom

    # Rust - za buildanje ELP-a
    pkgs-unstable.cargo
    pkgs-unstable.rustc
    pkgs-unstable.rustup
    llvmPackages_9.llvm-polly
    
    # Dependency for telescope (vim plugin)
    ripgrep
    pkgs-25-05.nodejs

    ## ascii tablica
    ascii

    # nix lsp
    nixd

    # c/c++ lsp
    ccls

    libxml2
    pkgs-unstable.postman

    # for markdown preview
    #nodejs_21
    yarn

    # telnet
    inetutils
    dig

    (import ./scripts/dummy.nix {pkgs=pkgs;})
    (import ./scripts/app.nix {inherit pkgs;})

    _1password

    pkg-config
    autoconf-archive
    autoconf

    # OCaml
    opam
    
    # luakit
    luakit
    # OpenSCAD
    pkgs-24.openscad
    pkgs-24.openscad-lsp
  ];

  environment.variables.EDITOR = "nvim";
  environment.etc."current-system-packages".text =
    let
      packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
      formatted = builtins.concatStringsSep "\n" packages;
    in
      formatted;

  fonts.packages = with pkgs; [
	nerdfonts
  ];

  programs.bash = {
    interactiveShellInit = ''
	    alias r3=rebar3
    	alias vim=nvim
	    alias copy_tmux="tmux show-buffer | xclip -selection clipboard"
    	export ERL_AFLAGS="-kernel shell_history enabled"

        export TERM='screen-256color'
        source ~/.config/rebar3/_rebar3
        '';
    promptInit = ''
          parse_git_branch() {
            git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
          }
          # Provide a nice prompt if the terminal supports it.
          if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
            PROMPT_COLOR="1;31m"
            ((UID)) && PROMPT_COLOR="1;32m"
              PS1="\n\[\033[$PROMPT_COLOR\]\[\e]0;\u@\h: \w\a\]\u@\h:\w\[\033[0;33m\]\$(parse_git_branch)\[\033[0;32m\] > \[\033[0m\]"
            if test "$TERM" = "xterm"; then
              PS1="\[\033]2;\h:\u:\w\007\]$PS1"
            fi
          fi
    '';
  };
  programs.gnome-terminal.enable = true;
  programs.tmux = {
  	clock24 = true;
  	enable = true;
	newSession = true;
	baseIndex = 1;
    escapeTime = 50;
	historyLimit = 2000;
    };



  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 5000 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
