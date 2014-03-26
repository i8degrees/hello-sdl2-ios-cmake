# This template derives from https://github.com/nddrylliog/hello-sdl2-ios6
#
# To build project from command line using the XCode project file generated with
# this CMake build script:
#
#     xcodebuild -configuration Debug -sdk iphonesimulator7.1 -arch i386
#
# See also: .cmake.sh script in this project's root directory
cmake_minimum_required( VERSION 2.8 )

# CMake Environment
set ( CMAKE_VERBOSE_MAKEFILE OFF CACHE PATH "Verbose Makefile" )
set ( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules" )
set ( CMAKE_TEMPLATE_PATH ${CMAKE_TEMPLATE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake/templates" )

option( NOM_BUILD_OSX "Toggle building for the Mac OS X platform" off )
option( NOM_BUILD_IOS "Toggle building for the iOS platform" on )

# Setup the SDK selection for backwards compatibility
  if( NOM_BUILD_IOS )

    # Override this platform and tell CMake to cross compile to iOS.
    SET( CMAKE_CROSSCOMPILING TRUE )
    SET( CMAKE_SYSTEM_NAME "Darwin" )
    SET( CMAKE_SYSTEM_PROCESSOR "arm" )

    # Setup the valid architectures.
    set( CMAKE_OSX_ARCHITECTURES "${ARCHS_STANDARD_32_BIT}" )
    # SET( CMAKE_OSX_ARCHITECTURES "${ARCHS_UNIVERSAL_IPHONE_OS}" )

    # Allow simulator and deploy.
    SET( CMAKE_XCODE_EFFECTIVE_PLATFORMS "-iphoneos;-iphonesimulator" )

    # FIXME:
    #
    # set( XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer" )

    set( SDKVER "7.1" )
    set( DEVROOT "/Applications/Developer/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer" )
    set( SDKROOT "${DEVROOT}/SDKs/iPhoneOS${SDKVER}.sdk" )

    IF( EXISTS ${SDKROOT} )
      # FIXME:
      #
      # SET( CMAKE_OSX_SYSROOT "${SDKROOT}" )
      # set( CMAKE_OSX_DEPLOYMENT_TARGET "${SDKVER}" )
      # set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -miphoneos-version-min=${SDKVER}" )

      # FIXME: we cannot enable this until *after* the project has been built
      # the first time, otherwise CMake freaks out about not being able to use
      # clang to build. This setting sets the Base SDK to the latest iOS build.
      #
      # If we do not have this set, we must manually set the SDK each time the
      # project file is regenerated.
      #
      # See also: http://www.ogre3d.org/forums/viewtopic.php?f=4&t=73613
      #
      # See also: CMake error message: "The C compiler
      # "/Applications/Developer/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"
      # is not able to compile a simple test program.
      #
      # SET( CMAKE_OSX_SYSROOT "iphoneos" )
    ELSE()
      MESSAGE( FATAL_ERROR "Error: iOS SDK ${SDKVER} not found at: ${SDKROOT}" )
    ENDIF()

    # FIXME: Verify if this setting is necessary. It was added in order to fix
    # linking errors complaining about not being able to find UIKit & OpenGLES.
    #
    # We may be able to remove adding a framework search path by fixing the
    # issue with CMAKE_OSX_SYSROOT.
    #
    # See also: FIXME note regarding CMAKE_OSX_SYSROOT.
    set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -F /Applications/Developer/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk/System/Library/Frameworks" )

  elseif( NOM_BUILD_OSX )
    set( SDKVER "10.8" ) # FIXME: This should be OS X v10.7
    set( DEVROOT "/Applications/Developer/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer" )
    set( SDKROOT "${DEVROOT}/SDKs/MacOSX${SDKVER}.sdk" )

    IF( EXISTS ${SDKROOT} )
      SET( CMAKE_OSX_SYSROOT "${SDKROOT}" )
      set( CMAKE_OSX_DEPLOYMENT_TARGET "${SDKVER}" )
      set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mmacosx-version-min=${SDKVER}" )
    ELSE()
      MESSAGE( FATAL_ERROR "Error: Mac OS X SDK ${SDKVER} not found at: ${SDKROOT}" )
    ENDIF()
  endif( NOM_BUILD_IOS )

if ( CMAKE_SYSTEM_NAME STREQUAL "Darwin" )
  set( NOM_PLATFORM_OSX true )

  # libc++ requires OSX v10.7+
  # set ( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -stdlib=libc++" )

  if ( CMAKE_GENERATOR STREQUAL "Xcode" )
    # set ( CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD "c++11" )
    # set ( CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY "libc++" )

    # FIXME
    set( XCODE_ATTRIBUTE_SDKROOT "iphoneos" )
  endif ( CMAKE_GENERATOR STREQUAL "Xcode" )

  if( NOM_BUILD_IOS )
    message( STATUS "Platform: iOS" )
  elseif( NOM_BUILD_OSX )
    message( STATUS "Platform: Darwin (Mac OS X)" )
  endif( NOM_BUILD_IOS )
endif( CMAKE_SYSTEM_NAME STREQUAL "Darwin" )

project( hello-sdl2-ios-cmake ) # $PROJECT_NAME

set( EXTERNAL_DEPS_DIR "third-party" )
set( MACOSX_BUNDLE_GUI_IDENTIFIER "net.i8degrees.${PROJECT_NAME}" )

set ( SRC_DIR "${PROJECT_SOURCE_DIR}/src" )

set ( SOURCES
      src/main.mm
    )

if( NOM_BUILD_IOS )
  set ( FRAMEWORKS
        Foundation
        AudioToolbox
        CoreGraphics
        QuartzCore
        ImageIO # SDL2_image
        UIKit
        OpenGLES
      )

  set ( EXT_DEPS
        "${PROJECT_SOURCE_DIR}/${EXTERNAL_DEPS_DIR}/ios/SDL2/libs/libSDL2.a"
        # FIXME
        # "${PROJECT_SOURCE_DIR}/${EXTERNAL_DEPS_DIR}/ios/SDL2_image/libs/libSDL2_image.a"
        "${PROJECT_SOURCE_DIR}/${EXTERNAL_DEPS_DIR}/ios/SDL2_ttf/libs/libSDL2_ttf.a"
      )

  set ( EXT_HEADERS
        "${PROJECT_SOURCE_DIR}/${EXTERNAL_DEPS_DIR}/ios/SDL2/include"
        "${PROJECT_SOURCE_DIR}/${EXTERNAL_DEPS_DIR}/ios/SDL2_image/include"
        "${PROJECT_SOURCE_DIR}/${EXTERNAL_DEPS_DIR}/ios/SDL2_ttf/include"
      )

elseif( NOM_BUILD_OSX )

  set ( EXT_DEPS
        "${PROJECT_SOURCE_DIR}/${EXTERNAL_DEPS_DIR}/osx/SDL2_framework"
        "${PROJECT_SOURCE_DIR}/${EXTERNAL_DEPS_DIR}/osx/SDL2_image.framework"
        "${PROJECT_SOURCE_DIR}/${EXTERNAL_DEPS_DIR}/osx/SDL2_ttf.framework"
      )

  set ( EXT_HEADERS
        "${PROJECT_SOURCE_DIR}/${EXTERNAL_DEPS_DIR}/osx/SDL2_framework/Headers"
        "${PROJECT_SOURCE_DIR}/${EXTERNAL_DEPS_DIR}/osx/SDL2_image.framework/Headers"
        "${PROJECT_SOURCE_DIR}/${EXTERNAL_DEPS_DIR}/osx/SDL2_ttf.framework/Headers"
      )
endif( NOM_BUILD_IOS )

if( NOM_BUILD_IOS )
  foreach(FW ${FRAMEWORKS})
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -framework ${FW}")
  endforeach()
elseif( NOM_BUILD_OSX )
  # TODO
endif( NOM_BUILD_IOS )

add_executable  ( ${PROJECT_NAME}
                  MACOSX_BUNDLE
                  ${HEADERS}
                  ${SOURCES}
                )

include_directories ( ${EXT_HEADERS} )

target_link_libraries ( ${PROJECT_NAME}
                        ${EXT_DEPS}
                      )

# Auto-generated source file
configure_file  ( "${CMAKE_TEMPLATE_PATH}/platforms.hpp.in"
                  "${SRC_DIR}/platforms.hpp"
                )

# Execute afterwards to run built app:
#
#     open -a "iPhone Simulator"
add_custom_command  ( TARGET
                      ${PROJECT_NAME}
                      POST_BUILD
                      COMMAND ${CMAKE_COMMAND}
                      -E copy_directory ${CMAKE_CURRENT_BINARY_DIR}/Debug-iphonesimulator/${PROJECT_NAME}.app /Developer/iPhoneSDKs/iPhoneSimulator7.1.sdk/Applications/${PROJECT_NAME}.app
                    )

# FIXME:
#
# set( CODESIGN_COMMAND "/usr/bin/codesign" )
# add_custom_command  ( TARGET
#                       ${PROJECT_NAME}
#                       POST_BUILD
#                       COMMAND ${CODESIGN_COMMAND}
#                       -s "${CMAKE_CURRENT_BINARY_DIR}/Debug-iphoneos/hello-sdl2-ios-cmake.app"
#                     )
