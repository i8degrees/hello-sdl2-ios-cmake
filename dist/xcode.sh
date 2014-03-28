#!/bin/sh
#
# This helper script must be ran from the project's build directory
#

xcodebuild -configuration Debug -sdk iphonesimulator7.1 -arch i386 build

