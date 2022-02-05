#!/bin/bash

set -e 

function error() {
    echo "$1" >&1;
    exit 1;
}

set +e
msgpack_library_dir=$(fd -uuu --maxdepth=1 --type=d "mpack.*")
if [[ ! -d "${msgpack_library_dir}" ]]; then
    error "Unable to find msgpack library"
fi
set -e

msgpack_library_path="${msgpack_library_dir}/libmpack.a"
if [ ! -f "$msgpack_library_path" ]; then
    echo "Building msgpack libraryk..."
    bash build-mpack.sh "$(pwd)/$msgpack_library_dir"
else
    echo "Using existing msgpack library: ${msgpack_library_path}";
fi

rust_library_path="../target/release"
gcc -I "${msgpack_library_dir}/src/mpack" -L "${msgpack_library_dir}" -L "${rust_library_path}" -L "/opt/homebrew/lib" -lmpack -lrlib_test -lonig "test.c"
