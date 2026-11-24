self: { config, lib, pkgs, ... }:
let
  cfg = config.programs."3d-slicer";
  system = pkgs.stdenv.hostPlatform.system;
in
{
  options.programs."3d-slicer".enable = lib.mkEnableOption "3D Slicer";

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = system == "x86_64-linux";
      message = "3D Slicer is only available on x86_64-linux.";
    }];
    environment.systemPackages = lib.optionals (system == "x86_64-linux") [
      self.packages.${system}.default
    ];
  };
}
