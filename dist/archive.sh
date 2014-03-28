#!/bin/sh

PROJECT_NAME="hello-sdl2-ios-cmake"

PROJECT_PATH="${HOME}/Projects/${PROJECT_NAME}.git"

# Built app bundle absolute path
PROJECT_APP_PATH="${HOME}/Projects/${PROJECT_NAME}.git/build/Debug-iphoneos/${PROJECT_NAME}.app"

# CMake build dir
PROJECT_BUILD_PATH="${PROJECT_PATH}/build"

/usr/bin/xcrun -sdk iphoneos PackageApplication -v ${PROJECT_APP_PATH} -o ${PROJECT_BUILD_PATH}/${PROJECT_NAME}.ipa
