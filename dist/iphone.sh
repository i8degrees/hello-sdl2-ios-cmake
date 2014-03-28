#!/bin/sh
#
# This helper script must be ran from the project's build directory
#

rm -rf /Developer/iPhoneSDKs/iPhoneSimulator7.1.sdk/Applications/hello-sdl2-ios-cmake.app
cp -av Debug-iphonesimulator/hello-sdl2-ios-cmake.app /Developer/iPhoneSDKs/iPhoneSimulator7.1.sdk/Applications/.
open -a "iPhone Simulator"
