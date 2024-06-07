{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  name = "pixelfed-nix-shell";
  buildInputs = with pkgs; [ act docker php83 php83Packages.composer nodejs nodePackages.npm mkcert ddev ];
  runScript = "$SHELL";
  shellHook = ''
      mkcert -install
      export PATH="$PWD/node_modules/.bin/:$PATH"
      export PATH="$PWD/vendor/bin/:$PATH"
  '';
}
