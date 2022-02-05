rlib-size-test
==============
Experiments with rust linking, trying to minimize size.

Conclusions: Rust stdlib itself isn't *that* bad.

For test.c as a static library: 2MB total (1.1MB total)
For test.c as a cdylib, 26kb for a.out *but* 439k for `librlib_test.dylib`


While "-Cprefer-dynamic" appears superficially to produce smaller binaries,
in reality it requires libstd.so is still around 5.5MB stripped :(
