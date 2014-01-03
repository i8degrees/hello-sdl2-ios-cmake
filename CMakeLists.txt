# This template derives from https://github.com/nddrylliog/hello-sdl2-ios6

cmake_minimum_required(VERSION 2.8)

project(hello-sdl2-ios-cmake) # PROJECT_NAME

set(SOURCES
    src/main.mm
)

set(IOS_FRAMEWORKS
    Foundation
    AudioToolbox
    CoreGraphics
    QuartzCore
    UIKit
    OpenGLES
)

# Override this platform and tell CMake to cross compile to iOS.
SET( CMAKE_CROSSCOMPILING TRUE )
SET( CMAKE_SYSTEM_NAME "Darwin" )
SET( CMAKE_SYSTEM_PROCESSOR "arm" )

# Setup the SDK selection.
SET( SDKVER "6.1" )
set( DEVROOT "/Applications/Developer/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer" )
SET( SDKROOT "${DEVROOT}/SDKs/iPhoneOS${SDKVER}.sdk" )

IF( EXISTS ${SDKROOT} )
  SET( CMAKE_OSX_SYSROOT "${SDKROOT}" )
ELSE()
  MESSAGE( FATAL_ERROR "Error: iOS SDK ${SDKVER} not found at: ${SDKROOT}" )
ENDIF()

# Setup the valid architectures.
SET( CMAKE_OSX_ARCHITECTURES "$(ARCHS_STANDARD_32_BIT)" )

# Allow simulator and deploy.
SET( CMAKE_XCODE_EFFECTIVE_PLATFORMS "-iphoneos;-iphonesimulator" )

foreach(FW ${IOS_FRAMEWORKS})
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -framework ${FW}")
endforeach()

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/libs/SDL/include
)
link_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/libs/SDL
)

set(MACOSX_BUNDLE_GUI_IDENTIFIER "net.i8degrees.${PROJECT_NAME}")

# FIXME: This is a hack to make Xcode happy. Better methods exist; see nomlib.md.
# set ( EXECUTABLE_OUTPUT_PATH "${CMAKE_CURRENT_BINARY_DIR}/build/Debug-iphoneos" ) #${CMAKE_BUILD_TYPE}

add_executable(
    ${PROJECT_NAME}
    MACOSX_BUNDLE
    ${HEADERS}
    ${SOURCES}
)

target_link_libraries ( ${PROJECT_NAME} SDL2 SDL2_image SDL2_ttf )
