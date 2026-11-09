# JustUS

JustUS is a private, two-person messaging app built with Flutter. It is designed around a secure, lock-first experience where communication is meant to feel personal, quick, and protected.

The app combines a modern chat UI with PIN-based access control, encrypted-style local security patterns, real-time messaging capabilities, and media support for text, images, voice, and view-once content.

## App overview

This project is not a generic social app. It is a focused mobile app for a single private conversation between two users. The product direction is clear from the codebase:

- secure app entry with a PIN gate
- session lock and auto-lock behavior
- private direct messaging
- typed replies, reactions, and starred messages
- media and voice note sharing
- search and settings in the chat experience
- local persistence with a database layer and cloud integration hooks

## What it is built with

JustUS is a Flutter application using a layered architecture and modern app tooling:

- Flutter + Dart
- Riverpod for state management
- GoRouter for navigation
- Drift for local database persistence
- Supabase for backend/cloud infrastructure
- Firebase for notifications and app setup
- Flutter Secure Storage for secure local storage
- `encrypt` and `pointycastle` for encryption-related handling
- `cached_network_image`, `image_picker`, `video_player`, `record`, and `just_audio` for media features

## Main features

### 1. PIN-protected access
The app starts on a PIN screen and routes to chat only after the session is authenticated. There is also session tracking and auto-lock logic, which is a strong signal that this app is built with privacy and device security in mind.

### 2. Private 1:1 chat experience
The chat screen is designed as a clean, Slack-inspired direct-message UI with:

- message bubbles
- text input bar
- reply functionality
- typing indicator
- star messages
- reactions
- copy/delete actions
- message list behavior for a personal conversation

### 3. Media-rich messaging
The app supports multiple message types beyond plain text, including:

- text messages
- images
- videos
- voice notes
- documents
- view-once media

### 4. Search and conversation management
The repository includes dedicated screens for:

- message search
- starred messages
- chat settings

This suggests a user experience designed around usability and controlled access to older messages.

### 5. Local-first + remote-ready architecture
The project is structured around layered app design:

- `lib/features` for app screens and interaction logic
- `lib/core` for routing, security, sessions, and theme
- `lib/data` for local/remote repositories and backend access
- `lib/domain` for shared enums and models

This is a clean architecture that separates UI, state, domain logic, and data access.

## Architecture summary

The core structure shows a fairly mature Flutter app design:

```text
lib/
├── app.dart
├── main.dart
├── firebase_options.dart
├── core/
│   ├── router/
│   ├── security/
│   └── theme/
├── data/
│   ├── local/
│   ├── remote/
│   └── repository/
├── domain/
│   ├── enums.dart
│   └── models/
├── features/
│   ├── chat/
│   └── pin_pad/
├── providers/
├── services/
└── ...
```

## Security and privacy focus

The repository clearly indicates the app is intended to be more private than a typical messaging app. Some of the strongest signs are:

- PIN-based session management
- app lock / redirect flow
- secure storage for sensitive values
- screen security hooks (temporarily disabled for debugging)
- view-once media support
- data separation between local and remote systems
- encryption-related dependencies

This is a strong privacy-first app concept rather than a casual demo project.

## Tech stack in plain English

This app is designed as a real-world mobile application that can behave like a secure, private messaging client with:

- a Flutter frontend for Android/iOS/mobile web compatibility
- local data persistence for fast offline behavior
- remote sync through Supabase
- push notifications through Firebase
- secure session handling using device storage and PIN logic

## Getting started

### Prerequisites

Before running the app, make sure you have:

- Flutter SDK 3.13.7 or newer
- Dart SDK matching the Flutter version
- Firebase project configured
- Supabase project configured
- Android Studio / Xcode / VS Code environment ready for Flutter development

### Install dependencies

```bash
flutter pub get
```

If code generation is needed:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Environment configuration

The app expects a `.env` file in `assets/.env`.

Example:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

The app loads this file during startup in `lib/main.dart` and initializes Supabase if values are present.

### Run the app

```bash
flutter run
```

## Firebase and Supabase setup

The repo includes:

- `lib/firebase_options.dart` for Firebase configuration
- `main.dart` initialization for Firebase and Supabase
- secure storage initialization

This means the app is prepared to work with real cloud services rather than behaving like a local-only prototype.

## Important development note

The code contains comments pointing out that some screen security features were temporarily disabled for debugging. That suggests the app is in active development and the security layer is intentionally being tuned during iteration.

## What I think this app is

Based on the code, this is best described as:

A private two-user messaging app with dual PIN/session protection, secure local storage, media sharing, cloud integration, and a polished chat UI. It feels like a personal, privacy-focused communication product rather than a starter template.

## Suggested README tagline

If you want a shorter one-line description for the project:

> JustUS is a private two-person chat app built with Flutter, combining PIN-protected access, secure session handling, real-time messaging, media sharing, and cloud-backed sync.

## License

No explicit license file was found in the repository metadata reviewed here. If this project is intended for public release, consider adding a `LICENSE` file before publishing it to GitHub.

---

This README was generated by analyzing the repository structure and the application code, especially the Flutter app entrypoint, router, security layer, and chat feature implementation.
