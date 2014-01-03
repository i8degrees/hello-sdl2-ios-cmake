# TODO #

- [ ] Fix the executable output path of our app bundle for Xcode; see **~/Notes/nomlib.md** for information on how to properly go about fixing this. In the mean time, the workaround is to copy the executable from **build/build/Debug-iphoneos** to **build/build**.

- [ ] Building for the iPhone Simulator is broken -- to fix this, we need to figure out what the linking problem with our compiled SDL2, SDL2_image & SDL2_ttf libraries. Workaround is to either a) swap between iphoneos7.0 & iphonesimulator7.0 copies of the libraries we've built; b) copy a built xcode archive over to **/Applications/Developer/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.0.sdk/Applications**.
