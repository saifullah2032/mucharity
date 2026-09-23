# Mucharity 💚

Mucharity is a modern Flutter fundraising mobile app designed to connect donors with impactful global causes. It is built with a feature-first architecture, robust state management, and a polished user experience.

## Features

- Browse featured and all campaigns with live funding progress and organizer details.
- Read rich campaign stories with parsed HTML content and embedded media.
- Switch between one-time and recurring donation options.
- Select preset impact levels or enter a custom donation amount.
- View transaction confirmation cards with status, timestamps, and transaction IDs.
- Enjoy a refined UI with a custom sage green palette and Plus Jakarta Sans typography.

## Tech Stack & Architecture

- **Framework:** Flutter (`>=3.2.0`)
- **State Management:** Riverpod (`StateNotifierProvider`, `FutureProvider`, `AsyncValue`)
- **Networking:** Dio with custom `BaseOptions`, timeouts, and `LogInterceptor`
- **Routing:** GoRouter with path parameters and payload passing via `extra`
- **HTML Parsing:** `flutter_widget_from_html`
- **Typography:** `google_fonts` (Plus Jakarta Sans)
- **Architecture Pattern:** Feature-first modular structure, repository pattern, manual JSON deserialization, and immutable state models with `copyWith`

## Getting Started

### Prerequisites

- Install the [Flutter SDK](https://docs.flutter.dev/get-started/install) version 3.2.0 or higher.
- Have an Android or iOS emulator available, or connect a physical device with USB debugging enabled.

### Installation Steps

```bash
cd mucharity
flutter pub get
flutter run
```

## Development & AI Assistance Disclosure

The architecture scaffolding and core structural planning were created by the author. AI collaboration tools were used selectively for debugging asynchronous workflows and refining UI/UX styling.

