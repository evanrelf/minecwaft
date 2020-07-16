{ pure ? false # Provide all required packages, for use with `nix-shell --pure`
}:

let
  pkgs = import ./nixpkgs.nix {};

  lib = pkgs.lib;

in
  pkgs.mkShell {
    buildInputs = with pkgs;
      [ terraform ] ++ lib.optional pure [ git nix ];

    shellHook = ''
      export NIX_PATH="nixpkgs=${pkgs.path}"

      command -v git >/dev/null \
        || echo "Warning: Couldn't find git in your PATH"

      command -v nix-instantiate >/dev/null \
        || echo "Warning: Couldn't find nix-instantiate in your PATH"

      test -n "$DIGITALOCEAN_TOKEN" \
        || test -n "$DIGITALOCEAN_ACCESS_TOKEN" \
        || echo "Warning: Missing ambient DigitalOcean credentials"

      test -f "$HOME/.aws/credentials" \
        || test -f "$AWS_SHARED_CREDENTIALS_FILE" \
        || test \( -n "$AWS_ACCESS_KEY_ID" -a -n "$AWS_SECRET_ACCESS_KEY" \) \
        || echo "Warning: Missing ambient AWS credentials"

      test -n "$SSH_AUTH_SOCK" \
        || echo "Warning: SSH_AUTH_SOCK isn't set"
    '';
  }
