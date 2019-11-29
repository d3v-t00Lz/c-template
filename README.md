# c-template

This is a skeleton project for a C program with a focus on unit testing.

This can be converted to a C library project with some relatively minor
updates to the `Makefile`.

# Features

- Unit test coverage report
- 100% unit test coverage out of the box
- Unit tests binary run through Valgrind to check for memory errors
- Benchmark suite
- `make rpm` target to generate an RPM package
- `make perf` target for running the benchmark suite through `perf stat`
- `make gprof` target for profiling the benchmark suite through `gprof`
- `make pahole` target for analyzing struct alignment using `pahole`

Run `make test` to execute the unit tests.

Run `make bench` to execute the benchmarks.

# Requirements

- dwarves/libdwarves (for `make pahole`)
- gcc (or bring your own compiler using `CC=$compiler make ...`)
- gcovr (for `make test` code coverage report)
- gdb (for `make debug`)
- gprof (for `make gprof`)
- perf (for `make perf`)
- valgrind (for `make test`)

