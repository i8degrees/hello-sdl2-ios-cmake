# Third-Party Dependencies #

[nomlib's](http://github.com/i8degrees/nomlib/) third-party dependencies. Pre-packaged libraries are available for the OS X and Windows platforms and may be found listed as nomlib_**\<PLATFORM\>-dependencies** at:

* [nomlib's sourceforge.net project files](http://sourceforge.net/projects/nomlib/files/)

## Installation ##

Download the package file for your platform and extract inside the root of your project folder for nomlib. You should now have several libraries populating third-party/**\<EXTRACTED_PLATFORM\>**. No other dependency hell to ensure -- yay!

## Packaged Libraries ##

Both the 64-bit and 32-bit official development binaries versions of:

* [SDL v2.0.2](http://libsdl.org/)
* [SDL_image v2.0.0](http://www.libsdl.org/projects/SDL_image/)
* [SDL_ttf v2.0.12](http://www.libsdl.org/projects/SDL_ttf/)

  * Packaged only under Mac OS X
      * [libsndfile v1.0.24](http://www.mega-nerd.com/libsndfile/)
        * Distributed framework is copied from the [SFML2 master branch](https://github.com/LaurentGomila/SFML/tree/master/) with me moving the distribution's **sndfile.h** file to it under a new Headers directory.

      * [SDL2_image.framework v2.0.0](http://libsdl.org/projects/SDL_image) built with SDL_IMAGE_USE_COMMON_BACKEND (in order to fix critical pixel mismatch issue; see also https://forums.libsdl.org/viewtopic.php?t=10013&highlight=perhaps+again+pixel+bug+mac).
        * [libpng v1.5.18](https://github.com/Homebrew/homebrew/commits/master/Library/Formula/libpng.rb) from Homebrew's repository with the --universal build flag.
        * [libtiff v4.0.3](https://github.com/Homebrew/homebrew/commits/master/Library/Formula/libtiff.rb) from Homebrew's repository with the --universal build flag.
        * [libjpeg 8d](https://github.com/Homebrew/homebrew/commits/master/Library/Formula/jpeg.rb) from Homebrew's repository with the --universal build flag.

  - Packaged only for Windows
    * [libsndfile v1.0.25](http://www.mega-nerd.com/libsndfile/)
    * [OpenAL Soft v1.15.1](http://kcat.strangesoft.net/openal.html)

## Licensing ##

Licensing files for each library can be found at the project root of your nomlib directory under LICENSE_**\<LIBRARY_NAME\>**.
