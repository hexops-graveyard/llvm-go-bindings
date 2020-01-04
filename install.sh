#!/usr/bin/env bash
set -e

skip_clone="${SKIP_CLONE:-false}"
clean_build="${CLEAN_BUILD:-true}"

if [[ ! -d "$GOPATH/src/llvm.org" ]] && [[ "$skip_clone" = "false" ]]; then
    # Clone our LLVM fork with the patches needed for building Go bindings on Windows.
    echo "Cloning LLVM Git repository (1.5 GiB download)..."
    git clone --config core.autocrlf=false https://github.com/hexops/llvm-project $GOPATH/src/llvm.org
    pushd $GOPATH/src/llvm.org/llvm
    git checkout llvmorg-9.0.1-windows
    popd
elif [[ "$skip_clone" = "true" ]]; then
    echo "Reusing existing LLVM repository clone $GOPATH/src/llvm.org"
else
    echo "directory already exists: $GOPATH/src/llvm.org"
    echo "please remove it and rerun this script (or set SKIP_CLONE=true)."
fi

if [[ "$OSTYPE" == "msys" ]]; then
    # Without setting this, the GOROOT outside of MSYS may conflict. We do use the
    # host GOPATH, though (which allows using the bindings on the host / outside of
    # MSYS2).
    export GOROOT=/mingw64/lib/go
fi

# Build LLVM for the Go bindings.
#
# BEWARE: A Debug build of LLVM will slow down linking under MSYS MinGW-w64 by several
# hours on a modern i7 machine, and will produce 70 GiB of binaries instead of just 
# the 2 GiB in Release mode.
pushd $GOPATH/src/llvm.org/llvm/bindings/go
if [[ -d "llvm/workdir" ]] && [[ "$clean_build" -eq "true" ]]; then
    echo "Cleaning prior build directory (set CLEAN_BUILD=false to develop changes to LLVM)..."
    rm -rf ./llvm/workdir
fi
echo "Building LLVM..."
./build.sh -G 'MSYS Makefiles' -DLLVM_WIN32_ENABLE_BINDINGS=1 -DCMAKE_BUILD_TYPE=Release
popd

# Build the Go bindings.
echo "Building the Go bindings..."
go install llvm.org/llvm/bindings/go/llvm

echo
echo 'Success!'
echo
echo 'Import the Go bindings:'
echo
echo '  import "llvm.org/llvm/llvm/bindings/go/llvm"'
echo
echo 'View the documentation:'
echo
echo '  https://godoc.org/llvm.org/llvm/bindings/go/llvm'
echo
