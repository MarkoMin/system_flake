{ pkgs } :
    pkgs.writeShellApplication {
        name = "dummy2";

        runtimeInputs =
            [ pkgs.lolcat
            pkgs.cowsay ];

        text = ''
        echo "dumm2" | cowsay | lolcat
        '';
                        
    }
