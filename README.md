# APP-002 — Fitness Universe

Independent Flutter Android/iOS workout journal for a global audience.

## Current functionality
- Save workouts (walking, running, cycling, strength training, yoga).
- Track workout duration and accumulated minutes.
- Persist, reload and delete workouts locally.
- Localized UI resources: **English (en), Turkish (tr), Arabic (ar)**.
- Locale-aware history dates and Material localization (including Arabic RTL layout).
- Serialization and persistence unit tests, GitHub Actions workflow.

## Build locally
Requires Flutter SDK:

```sh
flutter create --platforms=android,ios .
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
flutter run
```

Native Android/iOS folders are not committed in this initial phase. CI generates the platform scaffolding before analysis and tests. No device build has been verified.

## Privacy and safety
Workout data is stored on-device via shared_preferences. This is **not encrypted**, so do not store sensitive health diagnoses or clinical records. No account, analytics SDK, advertising SDK or external network transmission is implemented yet. This app is not medical advice.

## International rollout
- Current translation files: en, tr, ar; translations and RTL require human review and widget/device testing.
- Planned: additional locales, locale-aware units and numeric entry, accessible controls, export/delete-all, consent controls, store listing translations, region-specific privacy notices and data retention policies.
- Planned: workout programs, charts, goals, reminders, subscriptions and optional rewarded ads subject to platform policies.

**Status:** Initial MVP code committed. Flutter analyze, tests, Android and iOS builds are not yet verified.
