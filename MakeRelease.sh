#!/bin/sh

if [ "$1" = "win7" ] ; then
	DSTVERSION="7"
	SUBDIR="win7"
elif [ "$1" = "winxp" ] ; then
	DSTVERSION="XP"
	SUBDIR="winxp"
else
	echo "Usage: MakeRelease.sh [win7|winxp]"
	exit
fi

if [ "$2" = "amd64" ] ; then
	ARCH="amd64"
else
	ARCH="i386"
fi

DSTDIR="Release $DSTVERSION $ARCH"
ARCHIVE="ghost-win$DSTVERSION-$ARCH.zip"
if [ "$DSTVERSION" = "7" ] ; then
	OBJDIR="win7"
elif [ "$DSTVERSION" = "XP" ] ; then
	OBJDIR="wxp"
fi

if [ -d "$DSTDIR" ] ; then
	rm -rf "$DSTDIR"/*
else
	mkdir "$DSTDIR"
fi

if [ -f "$ARCHIVE" ] ; then
	rm "$ARCHIVE"
fi

cp AUTHORS "$DSTDIR"
cp CHANGELOG "$DSTDIR"
cp COPYING "$DSTDIR"
cp INSTALL "$DSTDIR"
cp README "$DSTDIR"

if [ "$DSTVERSION" = "XP" ] ; then
	cp "${SUBDIR}/ghostbus.inf" "$DSTDIR"
	cp "${SUBDIR}/ghostdrive.inf" "$DSTDIR"
elif [ "$DSTVERSION" = "7" ] ; then
	cp "${SUBDIR}/Miniport/ghostport.inf" "$DSTDIR"
	cp "${SUBDIR}/Readonly/ghostreadonly.inf" "$DSTDIR"
fi

cp "${SUBDIR}"/bin/"${ARCH}"/*.{exe,dll,sys} "$DSTDIR"
cp "${SUBDIR}"/GhostLib/ghostlib.h "$DSTDIR"
cp "${SUBDIR}"/GhostGUI/bin/Release/GhostGUI.exe "$DSTDIR"
cp "${SUBDIR}"/PythonBindings/*.py "$DSTDIR"

cd "$DSTDIR"
zip "../$ARCHIVE" *
cd ..

if [ "$DSTVERSION" = "XP" ] ; then
	if [ -f WdfCoInstaller01009.dll ] ; then
		cp WdfCoInstaller01009.dll "$DSTDIR"
	fi
	if [ -f WUDFUpdate_01009.dll ] ; then
		cp WUDFUpdate_01009.dll "$DSTDIR"
	fi
fi
