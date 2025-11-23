# Flutter Weather Dashboard 🌤️

A comprehensive weather dashboard application built with Flutter for educational purposes. This project demonstrates modern Flutter development practices, API integration, local data persistence, and responsive UI design.

## 📋 Overview

This weather dashboard application provides real-time weather information with a beautiful and intuitive user interface using the **Open-Meteo API** - a free, open-source weather API that requires no API key.

## ✨ Features

- **Open-Meteo API Integration**: Fetch real-time weather data using the free Open-Meteo API (no API key required)
- **Real-time Weather Data**: Get current temperature, wind speed, and weather conditions by coordinates
- **Local Data Persistence**: Save and retrieve weather data using SharedPreferences
- **Date & Time Formatting**: Display formatted dates and times using the intl package
- **Responsive UI**: Beautiful Material Design interface that works across platforms
- **Weather Dashboard**: Comprehensive view of weather conditions with detailed metrics
- **Cross-Platform**: Runs on Android, iOS, Web, Windows, macOS, and Linux

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.10.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- A device or emulator for testing

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/JanithAberathna/Flutter-Weather_App.git
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   
   For Chrome/Web:
   ```bash
   flutter run -d chrome
   ```
   
   For Android Emulator:
   ```bash
   flutter run -d android
   ```
   
   For iOS Simulator (macOS only):
   ```bash
   flutter run -d ios
   ```
   
   For Windows (requires Developer Mode):
   ```bash
   flutter run -d windows
   ```

## 📦 Dependencies

This project uses the following packages:

- **flutter**: Core Flutter SDK
- **http (^1.1.0)**: For making HTTP requests to weather APIs
- **shared_preferences (^2.2.2)**: For local data storage and persistence
- **intl (^0.18.1)**: For internationalization and date formatting
- **cupertino_icons (^1.0.8)**: iOS-style icons

## 🏗️ Project Structure

```
lib/
├── main.dart           # Main application entry point and weather dashboard
test/
├── widget_test.dart    # Widget tests
android/                # Android-specific code
ios/                    # iOS-specific code
web/                    # Web-specific code
windows/                # Windows-specific code
linux/                  # Linux-specific code
macos/                  # macOS-specific code
```

## 🎓 Learning Objectives

This project demonstrates the following Flutter concepts:

1. **Widget Composition**: Building complex UIs with Flutter widgets
2. **State Management**: Managing application state with StatefulWidget
3. **HTTP Networking**: Making API calls and handling responses
4. **Async Programming**: Using Future and async/await patterns
5. **Local Storage**: Persisting data with SharedPreferences
6. **Date Formatting**: Using the intl package for localization
7. **Material Design**: Implementing Material Design principles
8. **Cross-Platform Development**: Writing code that runs on multiple platforms

## 🔧 Configuration

### API Configuration

This app uses the **Open-Meteo API** (https://open-meteo.com/), which is:
- ✅ **Free and open-source**
- ✅ **No API key required**
- ✅ **No registration needed**
- ✅ **No rate limiting for reasonable use**

The API endpoint is already configured in `main.dart`:
```dart
https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&current=temperature_2m,wind_speed_10m,weather_code
```

Simply enter latitude and longitude coordinates to fetch weather data!

## 📱 Platform-Specific Notes

### Windows
- Requires Developer Mode to be enabled for symlink support
- Run `start ms-settings:developers` to open Developer Mode settings

### Web
- Works out of the box with Chrome, Edge, or other modern browsers
- No additional configuration needed

### Android/iOS
- Requires an emulator or physical device
- May need additional platform-specific permissions for location services

## 🤝 Contributing

This is an educational project. Feel free to fork, modify, and use it for learning purposes. Contributions, suggestions, and improvements are welcome!

## 📄 License

This project is created for educational purposes. Feel free to use it as a learning resource.

## 👨‍💻 Author

**JanithAberathna**

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- [Open-Meteo](https://open-meteo.com/) for providing free, open-source weather data
- The Flutter community for continuous support and resources

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Material Design Guidelines](https://material.io/design)

---

**Note**: This project is built for educational purposes to demonstrate Flutter development concepts and best practices.
