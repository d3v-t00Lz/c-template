# c-template

This is a skeleton project for a C program with a focus on unit testing.

This can be converted to a C library project with some relatively minor
updates to the `Makefile`.

# Features

- Unit test coverage report
- 100% unit test coverage out of the box
- Unit tests binary run through Valgrind to check for memory errors
- `make rpm` target to generate an RPM package
- `make perf` target for running through `perf stat`

Run `make test` to execute the unit tests.

# Requirements

- gcc (or bring your own compiler using `CC=$compiler make ...`)
- valgrind (for `make test`)
- gcovr (for `make test` code coverage report)

