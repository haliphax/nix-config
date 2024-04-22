{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    extraModprobeConfig = ''
    	options snd-hda-intel dmic_detect=0
    '';
    kernelPackages = pkgs.linuxPackages_6_1;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  hardware.enableAllFirmware = true;
  hardware.pulseaudio.enable = true;
  sound.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  services.printing.enable = true;

  users.users.todd = {
    isNormalUser = true;
    description = "Todd";
    extraGroups = [ "audio" "docker" "networkmanager" "wheel" ];
    packages = with pkgs; [
      contour
      discord
      docker
      docker-buildx
      docker-compose
      git
      google-chrome
      keepassxc
      neovim
      pavucontrol
      pulseeffects-legacy
      vscode
    ];
  };

  environment.sessionVariables = {
    PYENV_ROOT="$HOME/.pyenv";
    # pyenv flags to be able to install Python
    CPPFLAGS="-I${pkgs.zlib.dev}/include -I${pkgs.libffi.dev}/include -I${pkgs.readline.dev}/include -I${pkgs.bzip2.dev}/include -I${pkgs.openssl.dev}/include -I${pkgs.ncurses.dev}/include -I${pkgs.sqlite.dev}/include -I${pkgs.xz.dev}/include";
    CXXFLAGS="-I${pkgs.zlib.dev}/include -I${pkgs.libffi.dev}/include -I${pkgs.readline.dev}/include -I${pkgs.bzip2.dev}/include -I${pkgs.openssl.dev}/include -I${pkgs.ncurses.dev}/include -I${pkgs.sqlite.dev}/include -I${pkgs.xz.dev}/include";
    CFLAGS="-I${pkgs.openssl.dev}/include";
    LDFLAGS="-L${pkgs.zlib.out}/lib -L${pkgs.libffi.out}/lib -L${pkgs.readline.out}/lib -L${pkgs.bzip2.out}/lib -L${pkgs.openssl.out}/lib -L${pkgs.ncurses.out}/lib -L${pkgs.sqlite.out}/lib -L${pkgs.xz.out}/lib";
    CONFIGURE_OPTS="-with-openssl=${pkgs.openssl.dev}";
    PYENV_VIRTUALENV_DISABLE_PROMPT="1";
  };

  environment.systemPackages = with pkgs; [
    bzip2
    gcc
    gnumake
    libffi
    ncurses
    openssl
    pyenv
    readline
    sqlite
    xz
    zlib
  ];

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  programs.ssh.extraConfig = ''
    SendEnv COLUMNS LANG LINES TERM
  '';

  system.stateVersion = "23.11";
}
