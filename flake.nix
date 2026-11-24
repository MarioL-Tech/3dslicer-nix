{
  description = "Medical image visualization and analysis";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  outputs = { nixpkgs, ... }: {
    packages.x86_64-linux = rec {
      "3d-slicer" = nixpkgs.legacyPackages.x86_64-linux.callPackage ./package.nix { };
      default = nixpkgs.legacyPackages.x86_64-linux.callPackage ./package.nix { };
    };
  };
}
