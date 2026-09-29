# Expose nixpkgs-unstable as pkgs.unstable and pull a few self-contained packages from it.
# The system stays on the stable channel. Add a line here only when a package needs to be newer.
{ nixpkgs-unstable }:
final: prev:
let
  unstable = import nixpkgs-unstable {
    inherit (prev.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in
{
  inherit unstable;
  steam = unstable.steam;
  mangohud = unstable.mangohud;
}
