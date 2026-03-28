# 🧠 Mental Health AI — *HelpMe*

> A Flutter-based AI-powered mental health companion app designed to support users through guided meditation, journaling, breathing exercises, community support, and professional counselor booking.

---

## 📋 Table of Contents

- [About the Project](#about-the-project)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Environment Setup](#environment-setup)
- [Running the App](#running-the-app)
- [Screenshots](#screenshots)
- [Dependencies](#dependencies)
- [Contributing](#contributing)
- [License](#license)

---

## 🌟 About the Project

**HelpMe** is an AI-powered mental health companion built with Flutter. It combines modern AI (Google Gemini), real-time backend services (Supabase), and local-first storage (Hive) to provide users with a holistic mental wellness experience — accessible anytime, anywhere.

The app is designed with empathy at its core, offering tools like an AI chat companion, guided meditations with audio, breathing exercises, a private journal, helpline access, nearby hospital mapping, and a community forum — all within a clean, calming UI.

---

## ✨ Features

| Feature | Description |
|---|---|
| 🤖 **AI Chat** | Conversational mental health support powered by Google Gemini AI |
| 🧘 **Meditation** | Guided meditation sessions with embedded YouTube audio |
| 💨 **Breathing Exercises** | Animated breathing guide for anxiety and stress relief |
| 📓 **Journaling** | Private, local-first journal powered by Hive (offline capable) |
| 📊 **Mental Health Survey** | Initial self-assessment survey to tailor the experience |
| 🏥 **Hospital Map** | Find nearby mental health facilities using Google Maps & Geolocation |
| 📞 **Helplines** | Quick access to emergency mental health helpline numbers |
| 👥 **Community** | Post, share, and connect within a supportive community forum |
| 📅 **Counselor Booking** | Book sessions with certified mental health counselors |
| 🔔 **Preferences** | Personalise notification and wellness preferences |
| 🔐 **Authentication** | Secure sign up/login via Supabase Auth |

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter (Dart) |
| **AI** | Google Generative AI (Gemini) |
| **Backend / Auth / DB** | Supabase (PostgreSQL + Auth + Realtime) |
| **Local Storage** | Hive |
| **Maps** | Google Maps Flutter + Geolocator |
| **Media** | just_audio, youtube_player_flutter, youtube_player_iframe, youtube_explode_dart |
| **HTTP** | http |
| **Web Content** | webview_flutter, flutter_html |
| **UI / Fonts** | Google Fonts (Outfit), Material 3 |
| **Environment** | flutter_dotenv |
| **URL Handling** | url_launcher |

---

## 📁 Project Structure

```
helpme/
├── lib/
│   ├── main.dart                    # App entry point
│   └── features/
│       ├── auth/                    # Login & Sign Up pages
│       ├── navigation/              # Bottom navigation shell
│       ├── home/                    # Core features
│       │   └── presentation/pages/
│       │       ├── home_page.dart
│       │       ├── ai_chat_page.dart
│       │       ├── meditation_page.dart
│       │       ├── breathing_page.dart
│       │       ├── journaling_page.dart
│       │       ├── survey_page.dart
│       │       ├── helpline_page.dart
│       │       ├── hospital_map_page.dart
│       │       ├── explore_page.dart
│       │       └── preferences_page.dart
│       ├── booking/                 # Counselor booking & dashboard
│       ├── community/               # Community posts & forum
│       ├── resources/               # Mental health resources
│       └── profile/                 # User profile
├── .env                             # Environment variables (gitignored)
├── pubspec.yaml
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.10.4
- Dart SDK ≥ 3.10.4
- Android Studio / VS Code with Flutter extension
- A [Supabase](https://supabase.com/) project
- A [Google Generative AI (Gemini)](https://ai.google.dev/) API key
- A [Google Maps](https://developers.google.com/maps) API key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/krishlanjewar/Mental-health-AI.git
   cd Mental-health-AI/helpme
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

### Environment Setup

Create a `.env` file in the root of the `helpme/` directory:

```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GEMINI_API_KEY=your_google_gemini_api_key
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
```

> ⚠️ **Never commit your `.env` file** to version control. It is already listed in `.gitignore`.

For Android, also add your Google Maps API key to `android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

---

## ▶️ Running the App

```bash
# Run on a connected device or emulator
flutter run

# Run in release mode
flutter run --release

# Build APK
flutter build apk --release
```

---

## 📦 Dependencies

| Package | Version | Purpose |
|---|---|---|
| `google_generative_ai` | ^0.4.7 | Gemini AI chat |
| `supabase_flutter` | ^2.12.0 | Auth, database, real-time |
| `hive` + `hive_flutter` | ^2.2.3 / ^1.1.0 | Local journal storage |
| `google_fonts` | ^7.0.2 | Outfit font family |
| `google_maps_flutter` | ^2.14.2 | Hospital map |
| `geolocator` | ^14.0.2 | User location |
| `just_audio` | ^0.9.34 | Audio playback |
| `youtube_player_flutter` | ^9.1.3 | YouTube player |
| `youtube_player_iframe` | ^5.2.2 | YouTube iframe player |
| `youtube_explode_dart` | ^3.0.5 | YouTube metadata |
| `flutter_dotenv` | ^6.0.0 | Environment variables |
| `webview_flutter` | ^4.13.1 | In-app web views |
| `flutter_html` | ^3.0.0 | HTML content rendering |
| `http` | ^1.6.0 | HTTP requests |
| `url_launcher` | ^6.3.2 | Launch external URLs |
| `intl` | ^0.20.2 | Date/time formatting |

---

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is for educational and personal use. All rights reserved © 2026 Krish Lanjewar.

---

<p align="center">Made with ❤️ and Flutter</p>
