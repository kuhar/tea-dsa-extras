#! /bin/bash

/home/kuba/projects/build-seahorn/release-5/run/bin/seapp ./temps/rippled.n.bc -o ./temps/rippled.n.pp.bc \
    --lower-invoke --devirt-functions --unfold-loops-for-dsa=false --simplify-pointer-loops \
    --horn-inline-constructors --horn-inline-allocators --log=extern.off --kill-vaarg=true \
    --externalize-addr-taken-funcs=true --promote-bool-loads=true --lower-switch=false \
    --promote-assumptions=false --instnamer \
    --verify-after-all=true --sea-verifier-noop --log="debug-verifier"
