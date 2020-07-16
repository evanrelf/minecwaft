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

  networking.firewall.allowedTCPPorts = [ 25565 ];

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  docker-containers.minecwaft = {
    image = "itzg/minecraft-server";
    ports = [ "25565:25565" ];
    volumes = [ "/var/minecwaft/data:/data" ];
    workdir = "/var/minecwaft";
    log-driver = "journald";

    environment = {
      EULA = "TRUE";

      VERSION = "1.16.1";
      TYPE = "PAPER";
      PAPERBUILD = "91";

      SERVER_NAME = "minecwaft";
      MOTD = "minecwaft";

      MODE = "survival";
      DIFFICULTY = "normal";
      MAX_PLAYERS = "10";
      SPAWN_PROTECTION = "0";
      OPS = "evanrelf";

      GUI = "FALSE";
      INIT_MEMORY = "1G";
      MAX_MEMORY = "3700M";
    };
  };

  system.activationScripts.minecwaft = "mkdir -p /var/minecwaft/data";
}
