# How to find a new SRI when buming package

SRI is hash encoded to base64 starting with "sha256-...."

This hash cooresponds to the hash of the extracted directory and you can get one by runningn:

    nix-prefetch-url --unpack https://<path_to_tarball>

You'll get raw base32 encoded hash. Not transform it to SRI by calling:
    
    nix hash to-sri --type sha256 <hash_from_prev_command>

Now you have it!
