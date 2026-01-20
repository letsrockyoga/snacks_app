# Platform Support Status

## ✅ Fully Supported Platforms

### Mobile
- **Android** (API 24+) - Full support with notifications
- **iOS** (iOS 12+) - Full support with background modes

### Desktop
- **Windows** (Windows 10+) - Full support
- **macOS** (10.14+) - Full support
- **Linux** (Ubuntu 20.04+, Fedora 35+) - Full support

### Web
- **Chrome, Firefox, Safari, Edge** - Full support (PWA capable)

## Platform-Specific Features

| Feature | Android | iOS | Windows | macOS | Linux | Web |
|---------|---------|-----|---------|-------|-------|-----|
| Notifications | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️* |
| Background Timer | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️* |
| Firebase Sync | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Offline Mode | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Calendar | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

*Web notifications require user permission and work only when browser tab is open

## Quick Start by Platform

### Android
```bash
flutter run -d android
```
Requires: Android SDK, Android device/emulator

### iOS
```bash
flutter run -d ios
```
Requires: Xcode, macOS, iOS device/simulator

### Windows
```bash
flutter run -d windows
```
Requires: Visual Studio 2022 with C++ tools

### macOS
```bash
flutter run -d macos
```
Requires: Xcode, macOS 10.14+

### Linux
```bash
flutter run -d linux
```
Requires: GTK 3, pkg-config, ninja-build

### Web
```bash
flutter run -d chrome
```
Requires: Chrome browser

## Distribution

- **Android**: Google Play Store (APK/AAB)
- **iOS**: Apple App Store (IPA)
- **Windows**: Microsoft Store / Direct download (EXE)
- **macOS**: Mac App Store / Direct download (DMG)
- **Linux**: Snap Store / Flatpak / AppImage
- **Web**: Any web hosting / Firebase Hosting
