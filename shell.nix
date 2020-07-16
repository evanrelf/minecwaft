let
  pkgs = import ./nixpkgs.nix {};

in
  pkgs.mkShell {
    buildInputs = with pkgs; [
      git
      nix
      terraform
    ];
  }
