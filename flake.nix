{
  description = "MelVM Benchmark Environment";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.naersk.url = "github:nix-community/naersk";
  inputs.mozilla = { url = "github:mozilla/nixpkgs-mozilla"; flake = false; };
  inputs.melorun-repo = { url = "github:themeliolabs/melorun"; flake = false; };

  outputs =
    { self
    , nixpkgs
    , mozilla
    , flake-utils
    , melorun-repo
    , naersk
    } @inputs:
    let rustOverlay = final: prev:
          let rustChannel = prev.rustChannelOf {
            channel = "1.58.0";
            sha256 = "sha256-eQBpSmy9+oHfVyPs0Ea+GVZ0fvIatj6QVhNhYKOJ6Jk=";
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
        rustChannel = pkgs.rustChannelOf {
          channel = "1.58.0";
          sha256 = "sha256-eQBpSmy9+oHfVyPs0Ea+GVZ0fvIatj6QVhNhYKOJ6Jk=";
        };
        naersk-lib = naersk.lib."${system}".override {
          cargo = rustChannel.rust;
          rustc = rustChannel.rust;
        };
        melorun = naersk-lib.buildPackage {
          pname = "melorun";
          root = melorun-repo;
          release = true;
        };

        in {
          devShell = pkgs.mkShell {
            #RUST_BACKTRACE=1;

            buildInputs = with pkgs; [
              melorun
              clang
              openssl
              (rustChannel.rust.override { extensions = [ "rust-src" ]; })
            ];
          };
        });
}
