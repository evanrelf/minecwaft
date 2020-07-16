variable "droplet_ssh_key_name" {
  type = string
}

variable "droplet_name" {
  type    = string
  default = "minecwaft"
}

variable "droplet_region" {
  type    = string
  default = "sfo2"
}

variable "droplet_size" {
  default = "s-2vcpu-4gb"
}

provider "digitalocean" {
  version = "~> 1.20.0"
}

provider "aws" {
  version = "2.70.0"
  region = "us-west-1"
}

provider "external" {
  version = "~> 1.2"
}

provider "null" {
  version = "~> 2.1"
}

module "deploy_nixos" {
  source = "github.com/tweag/terraform-nixos//deploy_nixos?ref=4979e668444529438d42f5230a59d2388dd65f86"
  nixos_config = "./configuration.nix"
  NIX_PATH = "nixpkgs=./nixpkgs.nix:nixpkgs-overlays="
  target_host = digitalocean_droplet.droplet.ipv4_address
}

data "digitalocean_image" "image" {
  name   = "NixOS" # Located in sfo2
  source = "user"
}

data "digitalocean_ssh_key" "do_ssh_key" {
  name = var.droplet_ssh_key_name
}

resource "digitalocean_droplet" "droplet" {
  image    = data.digitalocean_image.image.id
  name     = var.droplet_name
  region   = var.droplet_region
  size     = var.droplet_size
  ssh_keys = [data.digitalocean_ssh_key.do_ssh_key.id]
}

output "public_ip" {
  value = digitalocean_droplet.droplet.ipv4_address
}

terraform {
  required_version = "~> 0.12.20"
  backend "s3" {
    bucket = "evanrelf-terraform-state-minecwaft"
    region = "us-west-1"
    key    = "terraform.tfstate"
  }
}
