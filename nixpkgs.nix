args:

let
  # nixos-20.03 on 2020-07-11
  rev = "009c50976b5b8edcf7d871d1565bb060ed12a29c";
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    sha256 = "1cxij5h91j2q6gwpyihkyz3ikyjv4cqf01q3f5sjzn6s45z9zglp";
  };
in
  import nixpkgs ({ config = {}; } // args)
