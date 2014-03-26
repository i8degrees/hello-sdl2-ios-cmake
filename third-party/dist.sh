#!/bin/sh

# NOTE:
#
# This script assumes we are under the third-party directory of nomlib's
# project root.
#
# Prerequisites:
#
# SDL2_image framework compiled with SDL_IMAGE_USE_COMMON_BACKEND with built
# dylibs of libpng, libjpeg & libtiff (I've done so with homebrew's) linked in.
#
# See also: ~/Projects/third-party/SDL2_image.hg, branch xcode-tweaks.
#

THIRD_PARTY_OSX_PATH="./osx"
LIBPNG_LIB="/usr/local/lib/libpng15.15.dylib"
LIBJPEG_LIB="/usr/local/lib/libjpeg.8.dylib"
LIBTIFF_LIB="/usr/local/lib/libtiff.5.dylib"

INSTALL_NAME_TOOL=$(which install_name_tool)

SDL2_IMAGE_LIB_PATH="${THIRD_PARTY_OSX_PATH}/SDL2_image.framework/SDL2_image"

LIBPNG_RPATH="-change ${LIBPNG_LIB} @rpath/SDL2_image.framework/Frameworks/libpng15.15.dylib"
LIBJPEG_RPATH="-change ${LIBJPEG_LIB} @rpath/SDL2_image.framework/Frameworks/libjpeg.8.dylib"
LIBTIFF_RPATH="-change ${LIBTIFF_LIB} @rpath/SDL2_image.framework/Frameworks/libtiff.5.dylib"

LIBPNG_PATH="${THIRD_PARTY_OSX_PATH}/SDL2_image.framework/Frameworks/libpng15.15.dylib"
LIBPNG_ID="-id @rpath/SDL2_image.framework/Frameworks/libpng15.15.dylib"

LIBJPEG_PATH="${THIRD_PARTY_OSX_PATH}/SDL2_image.framework/Frameworks/libjpeg.8.dylib"
LIBJPEG_ID="-id @rpath/SDL2_image.framework/Frameworks/libjpeg.8.dylib"

LIBTIFF_PATH="${THIRD_PARTY_OSX_PATH}/SDL2_image.framework/Frameworks/libtiff.5.dylib"
LIBTIFF_ID="-id @rpath/SDL2_image.framework/Frameworks/libtiff.5.dylib"

# libtiff depends on libjpeg
LIBTIFF_LIBJPEG_RPATH="-change ${LIBJPEG_LIB} @rpath/SDL2_image.framework/Frameworks/libjpeg.8.dylib"

$INSTALL_NAME_TOOL ${LIBPNG_ID} ${LIBPNG_PATH}
$INSTALL_NAME_TOOL ${LIBJPEG_ID} ${LIBJPEG_PATH}
$INSTALL_NAME_TOOL ${LIBTIFF_ID} ${LIBTIFF_PATH}
$INSTALL_NAME_TOOL ${LIBTIFF_LIBJPEG_RPATH} ${LIBTIFF_PATH}

$INSTALL_NAME_TOOL ${LIBPNG_RPATH} ${SDL2_IMAGE_LIB_PATH}
$INSTALL_NAME_TOOL ${LIBJPEG_RPATH} ${SDL2_IMAGE_LIB_PATH}
$INSTALL_NAME_TOOL ${LIBTIFF_RPATH} ${SDL2_IMAGE_LIB_PATH}
