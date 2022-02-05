#!/bin/bash

set -e

msgpack_library_dir="$1"
if [[ ! -d "$msgpack_library_dir" ]]; then
    echo "Please specify msgpack library dir " >&2;
    exit 1;
fi
echo "Compiling msgpack library: ${msgpack_library_dir}"
pushd "${msgpack_library_dir}/src/mpack" >/dev/null
gcc -c -O2 *.c
echo "Archiving msgpack library"
popd > /dev/null
ar rc "${msgpack_library_dir}/libmpack.a" ${msgpack_library_dir}/src/mpack/*.o

