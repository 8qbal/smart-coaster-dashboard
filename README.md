# 💧 Smart Coaster Dashboard — Flutter Mobile App

A real-time mobile dashboard for displaying sensor data from an ESP32-based Smart Coaster hydration reminder system. Built with **Flutter** and **Firebase Realtime Database**.

## Screenshots

> _Build and run the app to see the premium dark-mode dashboard with real-time sensor data_

## Features

- 📊 **Real-time sensor data** — Temperature, Humidity, Distance, and Bottle Status
- 📈 **Trend chart** — Interactive temperature & humidity trends (last 1 hour)
- 🌙 **Dark / Light theme** — Persisted preference with smooth animated transitions
- 🟢 **Connection status** — Animated online/offline indicator (60s timeout)
- 🎨 **Premium UI** — Gradient accents, glassmorphism cards, Material 3 design
- 📱 **Mobile-first** — Optimized for portrait mode with bouncy scroll physics

## Architecture

```
lib/
├── main.dart                    # App entry, Firebase init, theme setup
├── config/
│   └── firebase_options.dart    # Firebase configuration
├── theme/
│   ├── app_theme.dart           # Light & dark Material3 themes
│   └── app_colors.dart          # Color palette & gradients
├── models/
│   └── sensor_data.dart         # SensorData model (from Firebase map)
├── services/
│   ├── firebase_service.dart    # Firebase RTDB stream listener
│   └── theme_service.dart       # SharedPreferences theme persistence
├── providers/
│   ├── sensor_provider.dart     # Sensor state + history management
│   └── theme_provider.dart      # Theme state management
├── screens/
│   └── dashboard_screen.dart    # Main dashboard screen
└── widgets/
    ├── sensor_card.dart         # Gradient-accented sensor card
    ├── connection_status.dart   # Animated online/offline dot
    ├── trend_chart.dart         # fl_chart line chart widget
    └── last_updated.dart        # Animated timestamp display
```

## Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter 3.29+** | Cross-platform UI framework |
| **Firebase Core** | Firebase initialization |
| **Firebase Database** | Real-time data from ESP32 |
| **fl_chart** | Temperature & humidity trend chart |
| **Provider** | State management |
| **Google Fonts** | Inter typography |
| **SharedPreferences** | Theme persistence |

## Setup Instructions

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.29+)
- Android Studio or VS Code with Flutter extension
- Android SDK (API 23+) or iOS development tools

### 1. Clone & Install

```bash
git clone <repository-url>
cd smart-coaster-dashboard
flutter pub get
```

### 2. Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com/) → Project `smart-coaster-c4cb1`
2. Add an Android app with package name `com.smartcoaster.dashboard`
3. Download `google-services.json` → place in `android/app/`
4. _(Optional)_ Run `flutterfire configure` for automated setup

### 3. Run

```bash
# On connected device or emulator
flutter run

# Build release APK
flutter build apk --release
```

## ESP32 Firebase Data Structure

The app listens to `SmartCoaster/status` in Firebase RTDB:

```json
{
  "temp": 28.5,
  "humidity": 65.2,
  "distance": 3.1,
  "bottle_present": true,
  "timestamp": 1711555200000
}
```

## License

MIT License — see LICENSE file for details.