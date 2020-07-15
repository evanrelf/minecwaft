# minecwaft

The most overkill way of deploying a Minecraft server.

A Minecraft server, running in a Docker container, running in a NixOS virtual
machine, hosted on DigitalOcean, provisioned using Terraform, with state managed
in an S3 bucket.

## Assumptions

This is written with my needs in mind, so lots of assumptions are made:

- **Local machine**
  - You have [Nix](https://nixos.org) installed
  - You have credentials for DigitalOcean and AWS ambiently available

- **DigitalOcean**
  - You want everything in the `sfo2` region because you're on the west coast
  - You have a DigitalOcean token available to Terraform (via the
    `DIGITALOCEAN_TOKEN` environment variable)
  - There exists a custom image named `NixOS` in the `sfo2` region, which
    provides the [NixOS](https://nixos.org) Linux distro

- **AWS**
  - You want everything in the `us-west-1` region because you're on the west
    coast
  - You have AWS credentials available to Terraform (via environment variables,
    `~/.aws/credentials`, etc.)
  - There exists an S3 bucket named `evanrelf-terraform-state-minecwaft` in the
    `us-west-1` region

I have no plans to generalize this for general consumption, but feel free to
poke around and steal anything you find useful.

## Usage

```
# Enter the Nix shell
$ nix-shell

# Initialize Terraform, its provider plugins, etc.
$ terraform init

# Realize your infrastructure
$ terraform apply

# TODO: Where's the Minecraft server?

# Destroy everything to save money
$ terraform destroy
```

## Todo

Remaining tasks:

- Write NixOS configuration
- Write scripts to automate configuration over SSH
- When starting a new server:
  - Copy NixOS system closure to DigitalOcean droplet
  - Switch to the new system configuration
- When continuing with an old server:
  - Restore an old droplet snapshot instead of creating a blank droplet
  - When finished, snapshot the droplet, then destroy it
