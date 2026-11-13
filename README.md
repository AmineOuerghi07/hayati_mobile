# Hayati

Habit tracker for iOS and Android.

Today greets you, shows the week, and lets you check a habit or count toward a target. Stats keeps the day, week, and month in rings that stay readable at 100%. The first launch offers a few starter habits and an optional reminder. English, Arabic, and French share one calm theme, with eight palettes.

## Run

Dev is the default flavor, so `flutter run` is enough. Production:

```bash
flutter run --flavor prod
```

Supabase is not connected yet. When it is, pass the URL and anon key at compile time. Do not commit them.

```bash
flutter run --flavor dev \
  --dart-define=SUPABASE_URL=https://example.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

`APP_FLAVOR` can override the Dart flavor (`dev` or `prod`) the same way.

## Checks

```bash
dart run build_runner build
flutter analyze
flutter test
```

Run the generator again after changing a Riverpod provider, and commit the generated file.

CI repeats those checks and also builds Android and iOS, then runs the guest flow on an emulator and a simulator. Store upload stays out until signing keys exist. See `docs/release.md`.
