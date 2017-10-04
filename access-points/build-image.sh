#!/bin/sh

[ $# -ge 1 ] || exit 1
CONTROL="$1"; shift
IMAGEBUILDER_URL=${IMAGEBUILDER_URL:-http://downloads.lede-project.org/snapshots/targets/ar71xx/generic/lede-imagebuilder-ar71xx-generic.Linux-x86_64.tar.xz}

TOPDIR="$PWD"
DLDIR=${DLDIR:-"dl"}
BUILDDIR=${BUILDDIR:-"build"}
IMAGEDIR=${IMAGEDIR:-"images"}

mkdir -p "$DLDIR"
mkdir -p "$BUILDDIR"; rm -rf "$BUILDDIR"/*
mkdir -p "$IMAGEDIR"

VERSION="$(basename "$(git describe --always --tags --dirty --match 'access-points/*')")"
IMAGEDIR="$IMAGEDIR"/"$VERSION"
mkdir "$IMAGEDIR"

imagebuilder="$(basename "$IMAGEBUILDER_URL")"

(
    cd "$DLDIR"
    wget --continue "$IMAGEBUILDER_URL" -O "$imagebuilder"
)

tar -C "$BUILDDIR" -axf "$DLDIR"/"$imagebuilder"

IMAGEBUILDER_DIR="$BUILDDIR"/"$(tar -atf "$DLDIR"/"$imagebuilder" | head -n1)"

image="lede-ar71xx-generic-tl-wr841-v10-squashfs-sysupgrade.bin"


(
    IFS='
'
    export PROFILE PACKAGES
    . "$CONTROL"

    tmp=$(mktemp --tmpdir -d files.XXXXXXXXX)

    cp -aLTv "$TOPDIR/$FILES" "$tmp"
    echo "$VERSION" > "$tmp"/etc/its-access-point-version

    cd "$IMAGEBUILDER_DIR"
    make image FILES="$tmp"
)

cp "$IMAGEBUILDER_DIR"/bin/targets/ar71xx/generic/"$image" "$IMAGEDIR"/

{
    printf '%s\n' "Date: $(date -R)"
    printf '%s\n' "Image-Builder: $IMAGEBUILDER_URL"
    printf '%s\n'
    printf 'Checksums-Sha512:\n'
    {
        ( cd "$DLDIR"   ; sha512sum "$imagebuilder" )
        ( cd "$IMAGEDIR"; sha512sum "$image")
    } | sed 's/^/  /'
} > "$IMAGEDIR"/image-manifest
