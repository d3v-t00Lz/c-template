#include <malloc.h>
#include <stdio.h>

#include "models/mystruct.h"


int _main(){
    struct MyStruct mystruct;
    MyStructFactory(&mystruct);
    printf(
        "Hello, World!\n%i\n%s\n",
        mystruct.a,
        mystruct.b
    );
    return 0;
}
