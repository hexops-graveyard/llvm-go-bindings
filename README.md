# llvm-go-bindings

Scripts for building the LLVM Go BIndings (including on Windows)

## Context

The LLVM project [has some excellent Go bindings](https://github.com/llvm/llvm-project/tree/master/llvm/bindings/go) but, unfortunately, building them is extremely difficult for people unfamiliar with building C++ projects. Additionally, it is impossible currently to compile them on Windows.

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

Clone this repository, and from a shell execute:

```sh
cd llvm-go-bindings
./install.sh
```

The bindings will be installed into `$GOPATH/src/llvm.org` and can be imported as:

```Go
import "llvm.org/llvm/llvm/bindings/go/llvm"
```

GoDoc can be viewed for now at https://godoc.org/llvm.org/llvm/bindings/go/llvm

## Known issues with Go LLVM bindings

For now I have filed these here as, unfortunately, I cannot file bug reports on LLVM yet due to account registration being done over email (https://bugs.llvm.org/enter_bug.cgi):

> New user self-registration is disabled due to spam. For an account please email bugs-admin@lists.llvm.org with your e-mail address and full name.

#### Impossible to build Go bindings on Windows using MSYS2

It is currently impossible to build the Go bindings on Windows (e.g. under MSYS2) due to two issues in the build configuration/scripts:

1. [`build.sh`](https://github.com/llvm/llvm-project/blob/master/llvm/bindings/go/build.sh#L11) cannot handle quoted arguments, which prevents passing `-G "MSYS Makefiles"` to the script -- making it impossible to generate MSYS-compatible Makefiles.
2. In [`config-ix.cmake`](https://github.com/llvm/llvm-project/blob/master/llvm/cmake/config-ix.cmake#L546-L547) WIN32 (i.e. non-Cygwin environments like MSYS or native Windows) explicitly disables building the Go bindings without any way to attempt building them.

A patch to resolve this issue is being maintained here: https://github.com/hexops/llvm-project/tree/llvmorg-9.0.1-windows

#### LLVM Go binding documentation on godoc.org is not updating

https://github.com/golang/gddo/issues/668

#### Versioned Go paths are not valid

According to the bindings/go/README.txt documentation:

> The package path "llvm.org/llvm/bindings/go/llvm" can be used to
> import the latest development version of LLVM from SVN. Paths such as
> "llvm.org/llvm.v36/bindings/go/llvm" refer to released versions of LLVM.

`llvm.org/llvm/bindings/go/llvm` does appear to be a valid Go package path as godoc.org is able to fetch the package contents for documentation generation:

https://godoc.org/llvm.org/llvm/bindings/go/llvm

But the versioned paths llvm.org/llvm.v36/bindings/go/llvm does not appear to be valid:

https://godoc.org/llvm.org/llvm.v36/bindings/go/llvm

This is an issue with the llvm.org website which is not responding correctly to the ?go-get=1 requests that are made. For example compare the `<meta>` tag output of:

```sh
$ curl -L https://llvm.org/llvm/bindings/go/llvm?go-get=1
...
<head>
  <meta http-equiv="refresh" content="0; url=/">
  <meta name="go-import" content="llvm.org/llvm svn https://llvm.org/svn/llvm-project/llvm/trunk">
</head>
...
```

vs:

```sh
$ curl -L https://llvm.org/llvm.v36/bindings/go/llvm?go-get=1
...
<html><head>
<title>404 Not Found</title>
</head><body>
<h1>Not Found</h1>
<p>The requested URL /llvm.v36/bindings/go/llvm was not found on this server.</p>
<hr>
<address>Apache/2.4.7 (Ubuntu) Server at llvm.org Port 443</address>
</body></html>
```
