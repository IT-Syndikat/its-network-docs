#!/bin/sh

[ $# -ge 1 ] || exit 1
CONTROL="$1"; shift
IMAGEBUILDER_URL=${IMAGEBUILDER_URL:-http://downloads.lede-project.org/snapshots/targets/ar71xx/generic/lede-imagebuilder-ar71xx-generic.Linux-x86_64.tar.xz}

TOPDIR="$PWD"
DLDIR=${DLDIR:-"dl"}
BUILDDIR=${BUILDDIR:-"build"}
IMAGESDIR=${IMAGEDIR:-"images"}

mkdir -p "$DLDIR"
mkdir -p "$BUILDDIR"; rm -rf "$BUILDDIR"/*
mkdir -p "$IMAGESDIR"

VERSION="$(basename "$(git describe --always --tags --dirty --match 'access-points/*')")"
IMAGEDIR="$IMAGESDIR"/"$VERSION"
mkdir -p "$IMAGEDIR"

imagebuilder="$(basename "$IMAGEBUILDER_URL")"

(
    cd "$DLDIR"
    wget --continue "$IMAGEBUILDER_URL" -O "$imagebuilder"
)

tar -C "$BUILDDIR" -axf "$DLDIR"/"$imagebuilder"

IMAGEBUILDER_DIR="$BUILDDIR"/"$(tar -atf "$DLDIR"/"$imagebuilder" | head -n1)"

# source control file and extract variables
profile=$(. "$CONTROL"; echo "${PROFILE}")
target=$(. "$CONTROL"; echo "${TARGET}")
subtarget=$(. "$CONTROL"; echo "${SUBTARGET}")

(
    # `make` below consumes these
    export PROFILE PACKAGES

    . "$CONTROL"

    tmp="$(mktemp --tmpdir -d files.XXXXXXXXX)"

    mkdir -p "$tmp"/etc
    echo "$VERSION" > "$tmp"/etc/its-access-point-version

    if [ -n "$COMMON_FILES" ]; then
            cp -aLTv "$TOPDIR/$COMMON_FILES" "$tmp"
    fi

    if [ -n "$FILES" ]; then
            cp -aLTv "$TOPDIR/$FILES" "$tmp"
    fi

    cd "$IMAGEBUILDER_DIR"
    unset COMMON_FILES
    make image FILES="$tmp" 1>&2
)

cp "$IMAGEBUILDER_DIR"/bin/targets/ar71xx/"${subtarget}"/openwrt*-"${target}-${subtarget}-${profile}"-squashfs-sysupgrade.bin "$IMAGEDIR"/

ln -snf "$VERSION" images/latest

{
    printf '%s\n' "Date: $(date -R)"
    printf '%s\n' "Image-Builder: $IMAGEBUILDER_URL"
    printf '%s\n'
    printf 'Checksums-Sha512:\n'
    {
        ( cd "$DLDIR"   ; sha512sum "$imagebuilder" )
        ( cd "$IMAGEDIR"; sha512sum openwrt*-"${target}-${subtarget}-${profile}"-squashfs-sysupgrade.bin )
    } | sed 's/^/  /'
} > "$IMAGEDIR"/"${profile}".image-manifest

echo
echo
echo "Wrote images to $IMAGEDIR"
echo
