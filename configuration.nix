{ lib, modulesPath, pkgs, ... }:

{
  imports =
    lib.optional (builtins.pathExists ./do-userdata.nix) ./do-userdata.nix ++ [
      (modulesPath + "/virtualisation/digital-ocean-config.nix")
    ];

  environment.systemPackages = with pkgs; [
    fd
    htop
    kakoune
    neovim
    ripgrep
    tmux
  ];

  networking.hostName = "minecwaft";

  networking.firewall.allowedTCPPorts = [
    25565 # Server
    25575 # RCON
  ];

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  docker-containers.minecwaft = {
    image = "itzg/minecraft-server";
    ports = [
      "25565:25565" # Server
      "25575:25575" # RCON
    ];
    volumes = [
      "/var/minecwaft/data:/data"
      "/var/minecwaft/plugins:/plugins"
    ];
    workdir = "/var/minecwaft";
    log-driver = "journald";

    environment = {
      # Server
      VERSION = "1.16.1";
      TYPE = "PAPER";
      PAPERBUILD = "91";

      # Metadata
      SERVER_NAME = "minecwaft";
      MOTD = "minecwaft";

      # Gameplay
      MODE = "survival";
      DIFFICULTY = "normal";
      SPAWN_PROTECTION = "0";
      # WORLD = "" # Can be a URL to ZIP file containing an archived world

      # Administration
      OPS = "evanrelf"; # Names separated by commas, e.g. "foo,bar,baz"
      MAX_PLAYERS = "10";
      # WHITELIST = "" # Names separated by commas, e.g. "foo,bar,baz"
      ENABLE_RCON = "true";
      RCON_PASSORD = "banana";

      # Performance
      INIT_MEMORY = "1G";
      MAX_MEMORY = "3700M";
      USE_AIKAR_FLAGS = "true";
      USE_LARGE_PAGES = "true";

      # Miscellaneous
      OVERRIDE_SERVER_PROPERTIES = "true";
      EULA = "true";
      TZ = "America/Los_Angeles";
    };
  };

  system.activationScripts.minecwaft = ''
    mkdir -p /var/minecwaft/{data,plugins}
  '';

  services.atd.enable = true;

  systemd.services.nightly-reboot = {
    script = "${pkgs.systemd}/bin/reboot";
    serviceConfig.type = "oneshot";
    startAt = "04:00:00";
  };

  time.timeZone = "America/Los_Angeles";
}
