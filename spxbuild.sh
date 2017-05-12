#!/bin/sh

# exit on any failure
set -e

#BUILDDIR="$PWD"/build/`echo $PLATFORM | tr 'A-Z' 'a-z'`/`echo $CONFIG | tr 'A-Z' 'a-z'`
BUILDDIR=$HOME/svn/dev/genesis/trunk/build/`echo $PLATFORM | tr 'A-Z' 'a-z'`

case $CONFIG in
    "Debug")
	DBGOPTS="CFLAGS=-O0 CXXFLAGS=-O0"
	;;
    "Release")
	DBGOPTS=
	;;
    *)
	echo 'ERROR: must define config' >&2
	;;
esac

OBJDIR="$PLATFORM"-objdir
[ -e "$OBJDIR" ] && rm -rf "$OBJDIR"
mkdir "$OBJDIR"
cd "$OBJDIR"

case $PLATFORM in
    "Linux64")
	../configure --prefix=$BUILDDIR --disable-static --disable-documentation $DBGOPTS
	;;
    *)
	echo 'ERROR: must define a platform' >&2
	;;
esac

make
make install

# remove libtool's .la file to avoid libtool using hardcoded rpath
# or some other dark magic
\rm $BUILDDIR/lib/libcoap-1.la
