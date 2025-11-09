{
  description = "ndisk development flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    system = "aarch64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    devShells.${system}.default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        rustc
        cargo
        gcc
        rustfmt
        clippy
        rustPlatform.cargoSetupHook
        openssl
        pkg-config
        alsa-lib
      ];
      buildInputs = with pkgs; [
      ];

      # Certain Rust tools won't work without this
      # This can also be fixed by using oxalica/rust-overlay and specifying the rust-src extension
      # See https://discourse.nixos.org/t/rust-src-not-found-and-other-misadventures-of-developing-rust-on-nixos/11570/3?u=samuela. for more details.
      RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    };
  };
}
