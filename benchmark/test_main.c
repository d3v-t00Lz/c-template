#include <assert.h>

#include "_main.h"
#include "test_main.h"

void TestMain(){
    int retcode = _main();
    assert(retcode == 0);
}
