{ lib, modulesPath, pkgs, ... }:

{
  imports = lib.optional (builtins.pathExists ./do-userdata.nix) ./do-userdata.nix ++ [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
  ];

  environment.systemPackages = with pkgs; [
    htop
    kakoune
    neovim
    tmux
    ripgrep
    fd
  ];

  networking.hostName = "minecwaft";

  networking.firewall.allowedTCPPorts = [ 22 25565 ];

  docker-containers.minecwaft = {
    image = "itzg/minecraft-server";
    ports = [ "25565:25565" ];
    volumes = [ "/var/minecwaft/data:/data" ];
    workdir = "/var/minecwaft";
    environment = {
      EULA = "TRUE";
      TYPE = "PAPER";
      PAPERBUILD = "208";
      VERSION = "1.15.2";
      SERVER_NAME = "minecwaft";
      MOTD = "minecwaft";
      ICON = builtins.path { name = "minecwaft-icon"; path = ./icon.png; };
      MAX_PLAYERS = "10";
      MODE = "survival";
      DIFFICULTY = "normal";
      SPAWN_PROTECTION = "0";
      OPS = "evanrelf";
      GUI = "FALSE";
      INIT_MEMORY = "1G";
      MAX_MEMORY = "3700M";
    };
  };

  system.activationScripts.minecwaft = ''
    mkdir -p /var/minecwaft/data
  '';
}
