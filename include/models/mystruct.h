/* An example struct
 */
struct MyStruct{
    int a;
    char b[20];
};

/* Allocates a new MyStruct on the heap
 *
 * @m: A MyStruct* to initialize from, use {} for default \0 values
 */
struct MyStruct *MyStructFactory(
    struct MyStruct *m
);

/* Return a string representation of @self on the heap
 */
char* MyStructRepr(
    struct MyStruct *self
);
