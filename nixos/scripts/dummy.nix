{ pkgs }:
    pkgs.writeShellScriptBin
            "dummy"
            ''
            echo "hello world" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat
            ''

