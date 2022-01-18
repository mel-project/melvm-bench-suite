{
  description = "Mel Intermediate Lisp";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.mozilla = { url = "github:mozilla/nixpkgs-mozilla"; flake = false; };

  outputs =
    { self
    , nixpkgs
    , mozilla
    , flake-utils
    , ...
    } @inputs:
    let rustOverlay = final: prev:
          let rustChannel = prev.rustChannelOf {
            channel = "1.58.0";
            sha256 = "sha256-6PfBjfCI9DaNRyGigEmuUP2pcamWsWGc4g7SNEHqD2c=";
          };
          in
          { inherit rustChannel;
            rustc = rustChannel.rust;
            cargo = rustChannel.rust;
          };
    in flake-utils.lib.eachDefaultSystem
      (system:
        let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (import "${mozilla}/rust-overlay.nix")
            rustOverlay
          ];
        };
        in {
          devShell = pkgs.mkShell {
            #RUST_BACKTRACE=1;
            buildInputs = with pkgs; [
              clang
              openssl
              (rustChannel.rust.override { extensions = [ "rust-src" ]; })
            ];
          };
        });
}
