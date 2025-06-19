{
  nixConfig = {
    substituters = [
      "https://hyprland.cachix.org"
    ];
    trusted-substituters = [
      "https://cachix.cachix.org"
      "https://nixpkgs.cachix.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs:
  let
    mkNixos = machineHostname: nixpkgsVersion: extraModules: {
      nixosConfigurations.${machineHostname} = nixpkgsVersion.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./users/common
          ./users/root
          ./hosts/common
          ./hosts/${machineHostname}
          inputs.agenix.nixosModules.default
          inputs.disko.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
        ] ++ extraModules;
      };
    };
    mkMerge = inputs.nixpkgs.lib.lists.foldl' (
      a: b: inputs.nixpkgs.lib.attrsets.recursiveUpdate a b
    ) { };
  in
  mkMerge [
    (mkNixos "installer-iso" inputs.nixpkgs [
      (inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
    ])
    (mkNixos "qemu-vm" inputs.nixpkgs [
    ])
  ];
}
