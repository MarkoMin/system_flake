{pkgs, lib, config, ...}: {
    options = {
        smartcards.enable = lib.mkEnableOption "Enables software for smartcards";
    };

    config = lib.mkIf config.smartcards.enable {
        environment.systemPackages = with pkgs; [
            pkcs11helper
            opensc
            libacr38u
            eid-mw
            pkg-config
            pcsclite
            pcsctools

        ];
      services.pcscd.enable = true;
      services.pcscd.plugins = [ pkgs.libacr38u ];
    };

}
