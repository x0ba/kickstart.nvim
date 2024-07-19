{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let
      forAllSystems = systems: f:
        nixpkgs.lib.genAttrs systems (system: f system);

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      devShellFor = system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.mkShell {
          packages = with pkgs; [ lua-language-server ];
        };
    in
    {
      devShells = forAllSystems supportedSystems (system: {
        default = devShellFor system;
      });
    };
}
