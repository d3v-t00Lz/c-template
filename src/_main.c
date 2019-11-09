#include <malloc.h>
#include <stdio.h>

#include "models/mystruct.h"


int _main(){
    struct MyStruct *mystruct = MyStructFactory(
        &(struct MyStruct){
            .a = 5,
            .b = "lol",
        }
    );
    printf(
        "Hello, World!\n%i\n%s\n",
        mystruct->a,
        mystruct->b
    );
    free(mystruct);
    return 0;
}
