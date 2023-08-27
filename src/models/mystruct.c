#include <assert.h>
#include <malloc.h>
#include <stdio.h>

#include "models/mystruct.h"

void MyStructFactory(
    struct MyStruct *self
){
    // Of course, you would want some real logic here
    *self = (struct MyStruct){.a = 5, .b = "lol"};
}

void MyStructRepr(
    struct MyStruct *self,
    char *buf,
    size_t size
){
    int written = snprintf(
        buf,
        40,
        "%s%i",
        self->b,
        self->a
    );
    assert(written < size);
}
