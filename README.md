# Hayati

Habit tracker for iOS and Android.

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
