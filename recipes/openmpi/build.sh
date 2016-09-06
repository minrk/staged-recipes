#!/bin/bash

OPTS="--disable-dependency-tracking"
if [[ $(uname) == Darwin ]]; then
    OPTS="$OPTS --disable-mpi-fortran"
fi

./configure --prefix=$PREFIX $OPTS

# Patches from https://bitbucket.org/petsc/conda-recipes
sedinplace() { [[ $(uname) == Darwin ]] && sed -i "" $@ || sed -i"" $@; }
sedinplace s%--prefix=$PREFIX%--prefix=\$PREFIX%g opal/include/opal_config.h
sedinplace s%-I$(dirname $SRC_DIR)%-I%g           opal/include/opal_config.h
sedinplace /-DOMPI_MSGQ_DLL=/d                    ompi/debuggers/Makefile

make
make check
make install
