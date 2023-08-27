#ifndef MYSTRUCT_H
#define MYSTRUCT_H

/* An example struct
 */
struct MyStruct{
    int a;
    char b[20];
};

/* Initialize a new MyStruct
 */
void MyStructFactory();

/* Return a string representation of @self on the heap
 */
void MyStructRepr(
    struct MyStruct *self,
    char *buf,
    size_t size
);

#endif  /* MYSTRUCT_H */
