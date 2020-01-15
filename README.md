# llvm-go-bindings

Scripts for building the LLVM Go BIndings (including on Windows)

## Context

The LLVM project [has some excellent Go bindings](https://github.com/llvm/llvm-project/tree/master/llvm/bindings/go) but, unfortunately, building them is extremely difficult for people unfamiliar with building C++ projects. Additionally, it is impossible currently to compile them on Windows with MSYS (i.e. without Cygwin).

This repository provides a script and concise instructions for building the LLVM Go bindings on Windows, Linux, and Mac OS easily.

## Prerequisites

### Windows

1. Install [Go 1.12+](https://golang.org/doc/install).
1. Install [Git for Windows](https://gitforwindows.org/).
1. Install [LLVM 9.0.0](http://releases.llvm.org/download.html#9.0.0) (see **Pre built binaries** section at bottom).
    - [Direct download link](http://releases.llvm.org/9.0.0/LLVM-9.0.0-win64.exe)
    - Choose **Add LLVM to the system PATH for all users**
1. Install MinGW-w64 via [MSYS2](http://www.msys2.org/):
    - Choose the **msys2-x86_64** version.
1. Install MSYS2 tools:
    - Launch a `MSYS2 MinGW 64-bit` command prompt
    - `pacman -S git make mingw-w64-x86_64-gcc mingw-w64-x86_64-cmake mingw-w64-x86_64-python3 mingw-w64-x86_64-go`

**IMPORTANT**: Windows Defender and other antivirus applications can slow down compilation by orders of magnitude, disable them before continuing!

Follow the steps provided below using a `MSYS2 MinGW 64-bit` command prompt.

### Mac OS

Work in progress, please file an issue if you are interested in trying this.

### Linux

Work in progress, please file an issue if you are interested in trying this.

## Building with prebuilt LLVM binaries

Work in progress.

## Building from source

This will download 1.5 GiB (the LLVM Git repository) and on a modern i7 laptop (i7-9750H + 16 GB RAM) will take approximately 60 minutes to complete.

From a shell, execute:

```sh
curl -Ls https://github.com/hexops/llvm-go-bindings/raw/master/installer.sh | sh
```

The LLVM repository will be checked out into `$GOPATH/src/llvm.org` and the bindings can be imported as:

```Go
import "llvm.org/llvm/llvm/bindings/go/llvm"
```

GoDoc can be viewed at https://godoc.org/llvm.org/llvm/bindings/go/llvm

## Known issues with Go LLVM bindings

There are some known issues with the Go LLVM bindings, which I've filed here:

- Impossible to build Go bindings on Windows using MSYS2: https://bugs.llvm.org/show_bug.cgi?id=44551
  - A patch to resolve this issue is being maintained here: https://github.com/hexops/llvm-project/tree/llvmorg-9.0.1-windows
- Versioned Go paths are not valid: https://bugs.llvm.org/show_bug.cgi?id=44550
