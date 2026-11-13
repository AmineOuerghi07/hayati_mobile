# Release

Hayati builds as two flavors.

- `dev` is the default. Its application id is `com.amineouerghi.hayati.dev`.
- `prod` is `com.amineouerghi.hayati`.

Android `minSdk` is 24 and `compileSdk` is 37, because the local notification plugin compiles against 37. That plugin also needs core library desugaring, which the app module enables. The Android build uses Gradle 9.5.0, Android Gradle Plugin 9.3.1, and Kotlin 2.4.20, which is the range Flutter 3.50 accepts. iOS deployment target is 15.0.

CI, on every push and pull request:

- analyzes and runs the unit and widget tests
- builds a dev debug APK and a prod release app bundle
- builds dev debug and prod release iOS without code signing
- runs `integration_test/guest_flow_test.dart` on an Android emulator and an iOS simulator

The prod release bundle is signed with the debug keystore so the build can be proven without store credentials. Replace that signing config before uploading to Play. iOS still needs a distribution certificate and a provisioning profile before TestFlight or the App Store. CI does not upload to either store.

Supabase is not linked. Auth, reminders, and sync work on the device. Pass `SUPABASE_URL` and `SUPABASE_ANON_KEY` with `--dart-define` only when those adapters exist. Do not commit the values.

Usage reports are off. The shipped analytics and crash reporter do nothing, even after the profile switch is turned on. A real reporter has to replace those providers and honor the switch.
