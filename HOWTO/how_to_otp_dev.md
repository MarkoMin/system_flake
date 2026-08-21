nix develop nixpkgs#erlang_28
export ERL_TOP=`pwd`
export MAKEFLAGS=-j${N} (npr. -j8 za 8 hyperthreadova)
sudo make clean

sudo ./otp_build configure --without-termcap --enable-builtin-zlib $configureFlags (bez systemd, hipe i wx)
ili hardkodirano
sudo ./otp_build configure --with-ssl=/nix/store/5926bc2bqkr0882p4m6yq3wy5brnbwlv-openssl-3.3.2 --with-ssl-incl=/nix/store/liqflvxvksmwmccjilmky0gwxmdk58x3-openssl-3.3.2-dev/ --enable-threads --enable-kernel-poll --without-termcap --enable-builtin-zlib
ili bez ssla
sudo ./otp_build configure --enable-threads --enable-kernel-poll --without-termcap --enable-builtin-zlib


sudo make
...

# Testiraj neki specifični suite
sudo make stdlib_test ARGS="-suite lists_SUITE"

# Proper testovi
sudo make stdlib_test ARGS="-suite calendar_prop_SUITE -pa <path_do_proper>/ebin"

## BEAM cheat-sheat

1. Tuplovi se koriste kao array u C-u. Korisne helper funkcije: `is_tuple/1`, `tuple_val/1` itd. Arity je prvi element liste. Pretvorba u konkretne tipove ide kroz `signed_val/1`, `unsigned_val/1` i slične helper funkcije.
