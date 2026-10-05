{
  description = "NixOS laptops: voidreliquary (Framework 13 Pro) and moonflower (ASUS Zephyrus G14).";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # AI coding agents. No nixpkgs follows: upstream builds against its own nixpkgs, which keeps its binary cache usable.
    llm-agents.url = "github:numtide/llm-agents.nix";
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Noctalia shell and greeter for the niri desktop. No nixpkgs follows: keeps noctalia.cachix.org usable.
    # The cachix branch only advances to commits that are already in the cache.
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      disko,
      catppuccin,
      llm-agents,
      ...
    }@inputs:
    let
      # One host = one directory under hosts/ and one line below.
      # The host's default.nix picks its desktop, users and optional modules by importing them.
      mkHost =
        hostname:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs hostname; };
          modules = [
            disko.nixosModules.disko
            catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [
                (import ./overlays/unstable.nix { inherit nixpkgs-unstable; })
                (import ./overlays/llm-agents.nix { inherit llm-agents; })
              ];

              # Home Manager runs inside nixos-rebuild: one command applies system and user config.
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "hm-backup";
                extraSpecialArgs = { inherit inputs hostname; };
                sharedModules = [ catppuccin.homeModules.catppuccin ];
              };
            }
            ./modules/base.nix
            ./hosts/${hostname}
          ];
        };
    in
    {
      # The installer uses the same disko revision and nixpkgs as this configuration.
      apps.x86_64-linux.disko = {
        type = "app";
        program = "${disko.packages.x86_64-linux.disko}/bin/disko";
      };

      nixosConfigurations = {
        voidreliquary = mkHost "voidreliquary";
        moonflower = mkHost "moonflower";
      };
    };
}
