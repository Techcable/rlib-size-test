#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

#include "mpack.h"

extern bool uses_ecosystem(const char *msgpack, size_t len, const char *target);

int main(int argc, char* argv[]) {
    char *data;
    size_t size;
    mpack_writer_t writer;
    mpack_writer_init_growable(&writer, &data, &size);

    mpack_write_cstr(&writer, "drill(\\d+)");

    if (mpack_writer_destroy(&writer) != mpack_ok) {
        fprintf(stderr, "An error occurred encoding the data!\n");
        return 1;
    }
    
    printf("Success: %d", uses_ecosystem(data, size, "drill52"));
    return 0;
}
