{
  description = "A Nix-flake-based Python development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
        KUBECONFIG = "/home/kosta/.kube/kind";
        shellHook = ''
            echo hi

          '';


          venvDir = ".venv";

          packages = with pkgs; [
            pulumictl
            gh
            yq
            kubeseal
            kubernetes-helm
            kubernetes
            argocd
            python312
            ] ++
            (with pkgs.python312Packages; [
              pip
              venvShellHook
            ]);
        };
      });
    };
}

