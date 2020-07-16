# minecwaft

The most overkill way of deploying a Minecraft server.

A Minecraft server, running in a Docker container, running in a NixOS virtual
machine, hosted on DigitalOcean, provisioned using Terraform, with state managed
in an S3 bucket.

Lots of credit goes to [itzg/docker-minecraft-server][docker-image], a super
configurable, batteries-included Docker image for running Minecraft servers.

I have no plans to generalize this for general consumption, but feel free to
poke around and steal anything you find useful.

## Assumptions

This is written with my needs in mind, so lots of assumptions are made:

### Local machine

- You have [Nix](https://nixos.org) installed
- You have Git installed
- You have credentials for DigitalOcean and AWS ambiently available
- You have the SSH key you want to use added to your running SSH agent

### DigitalOcean

- You want everything in the `sfo2` region because you're on the west coast
- You have a DigitalOcean token available to Terraform (via the
  `DIGITALOCEAN_TOKEN` environment variable)
- There exists a custom image named `NixOS` in the `sfo2` region, which
  provides the [NixOS](https://nixos.org) Linux distro

### AWS

- You want everything in the `us-west-1` region because you're on the west
  coast
- You have AWS credentials available to Terraform (via environment variables,
  `~/.aws/credentials`, etc.)
- There exists an S3 bucket named `evanrelf-terraform-state-minecwaft` in the
  `us-west-1` region

## Usage

```bash
# Enter the Nix shell
$ nix-shell

# Initialize Terraform, its provider plugins, etc.
$ terraform init

# Realize your infrastructure
$ terraform apply

# Play Minecraft with your non-techy friends :-)

# Destroy everything to save money
$ terraform destroy
```

[docker-image]: https://github.com/itzg/docker-minecraft-server
