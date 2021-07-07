# ipopt-fortran-example

Example of using Ipopt Fortran interface to solve a non-linear program.

Solves [problem 71](https://esa.github.io/pagmo2/docs/cpp/problems/hock_schittkowsky_71.html) from the
[Hock-Schittkowski test suite](https://doi.org/10.1007/978-3-642-48320-2).
Based on the [hs071_f](https://projects.coin-or.org/Ipopt/browser/stable/3.9/Ipopt/examples/hs071_f/hs071_f.f.in)
Fortran example provided with Ipopt, with updates to use a free-form layout and more modern Fortran syntax.

## Dependencies

The example requires GNU Fortran (tested with version 9.3.0) and GNU Make (tested with version 4.2.1) to build;
while it should be possible to use other Fortran compilers by changing the `FC` variable in the Makefile and translating
the flags to those appropriate to the compiler this hasn't been tested. An Ipopt installation is also required to
link against (tested with version 3.14.1).

On Ubuntu the necessary dependencies are provided by the packages [`gfortran`](https://packages.ubuntu.com/search?keywords=gfortran), [`build-essential`](https://packages.ubuntu.com/search?keywords=build-essential) and [`coinor-libipopt-dev`](https://packages.ubuntu.com/search?keywords=coinor-libipopt-dev) and can be installed using `apt`

```bash
sudo apt install build-essentials gfortran coinor-libipopt-dev
```

As a more cross platform alternative, [`conda`](https://docs.conda.io/en/latest/) can also be used to install all of the required dependencies on Linux and macOS. For example on Linux a new environment `ipopt` with the required dependencies can be created by running

```bash
conda create -n ipopt -c conda-forge gfortran_linux-64 Make ipopt
```

while the same can be achieved on macOS using

```bash
conda create -n ipopt -c conda-forge gfortran_osx-64 Make ipopt
```

The `gfortran_*-64` package by default only installs a binary named `x86_64-conda-*-gnu-gfortran` in the environment `bin` directory; a symbolic link can be created so this can instead by accessed by running `gfortran`, e.g. on Linux

```bash
conda activate ipopt
ln -s $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/gfortran
```


## Building and running the example

If the `libipopt` shared library is available on a standard library search path (for example, this will be this case if Ipopt was installed using the `coinor-libipopt-dev` Ubuntu package) then the example application can be built and run by running the following from the project root directory

```bash
make run
```

If `libipopt` is not on a standard library search path (for example if Ipopt was installed via `conda`) then an environment variable `LIBIPOPT_DIR` needs to be defined which points to the directory containing the `libipopt` shared library object before running. The variable assignment can be performed directly before the `make` command, for example

```bash
LIBIPOPT_DIR=/path/to/libopt/directory make run
```

