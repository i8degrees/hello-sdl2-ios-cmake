#!/bin/sh
#
# This helper script must be ran from the project's build directory
#

cmake -GXcode -DNOM_BUILD_IOS=on ..
