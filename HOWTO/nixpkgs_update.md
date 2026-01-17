# Bumping version

1. Create new branch from master, `update/<pkg_name>`
- update version
- update sha
- try to install locally `sudo nixos-rebuid -I <path_to_nixpkgs> switch` (do it in container, you don't want to mess-up your system)
    - make sure that system config is minimal becuase nothing will be cached (becuase local nixpkgs is prolly unstable)
2. Make a commit with message `<pkg_name>: update <V> -> <V2>`

# New package

1. Create new branch from master, `init/<pkg_name>`
2. Create a `default.nix` file which points to the derivation
3. Make a commit with message `<pkg_name>: init at <V>`
4. Submit a PR

# Update input registry

1. `nix flake lock --update-input nixpkgs_X`
