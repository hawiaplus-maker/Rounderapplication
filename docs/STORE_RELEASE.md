# Rounder — Store release guide

Everything needed to build, sign and upload the resident app to Google Play and
the App Store. Keep this file next to the release keystore backup.

## Identity

| Item | Value |
| --- | --- |
| App name | Rounder |
| Android application id / iOS bundle id | `com.futuretec.rounderapp.sa` |
| Version (this release) | `1.0.0+6` (`versionName 1.0.0`, `versionCode 6`) |
| Minimum Android | API 24 |
| Target Android | API 36 |
| Minimum iOS | 15.0 |
| Apple team | `KRHLXHF25D` |

The Android `applicationId` must never change after the first Play upload. It
matches the existing iOS bundle id.

## Android signing

The upload key was generated locally:

- Keystore: `android/app/upload-keystore.jks`
- Properties: `android/key.properties`
- Alias: `upload`

Both files are gitignored. **Back them up now** (password manager + encrypted
disk). Losing the upload key means you can no longer publish updates to the same
Play listing unless Play App Signing key reset is approved.

`android/app/build.gradle.kts` reads the key automatically. On a machine without
`key.properties` it falls back to debug signing so local release builds still
work; a store upload must be built on a machine that has the real keystore (or
with the CI secrets below).

### CI signing secrets

Add these repository secrets for `.github/workflows/android-apk.yml`:

| Secret | Value |
| --- | --- |
| `ANDROID_KEYSTORE_BASE64` | `base64 -i android/app/upload-keystore.jks` |
| `ANDROID_STORE_PASSWORD` | value of `storePassword` in `key.properties` |
| `ANDROID_KEY_PASSWORD` | value of `keyPassword` in `key.properties` |
| `ANDROID_KEY_ALIAS` | `upload` |

The workflow builds a signed **AAB** and uploads it with the Dart symbols. If the
secrets are absent it still builds, but with debug signing — that artifact is
for testing only and must not be uploaded.

## Build commands

```bash
flutter pub get

# Google Play (upload this file)
flutter build appbundle --release \
  --obfuscate --split-debug-info=build/symbols/android

# App Store (requires Xcode signing with team KRHLXHF25D)
flutter build ipa --release \
  --obfuscate --split-debug-info=build/symbols/ios
```

Outputs:

- `build/app/outputs/bundle/release/app-release.aab`
- `build/ios/ipa/*.ipa`

Keep `build/symbols/android` and `build/symbols/ios`: they are required to
symbolicate obfuscated crash reports. Bump the build number in `pubspec.yaml`
(e.g. `1.0.1+7`) for every store upload; both stores reject a reused build
number.

## Store assets

| Asset | Where |
| --- | --- |
| Play icon 512×512 | `store/play-icon-512.png` |
| App Store icon 1024×1024 (no alpha) | `store/appstore-icon-1024.png` |
| Play feature graphic 1024×500 | `store/play-feature-graphic-1024x500.jpg` |
| Phone screenshots | capture from a release build; Play needs at least 2, App Store needs the current 6.9" and 6.5" sizes |
| App description / keywords | not in the repo — write in the consoles |

Android adaptive icons are generated from `assets/images/logo1024.png`; the iOS
icon is generated without an alpha channel (Apple rejects transparency). After
changing the logo run:

```bash
dart run flutter_launcher_icons
```

## Google Play checklist

1. Create the app in Play Console with application id
   `com.futuretec.rounderapp.sa`.
2. Enable Play App Signing; upload the AAB to Internal testing first.
3. Complete **App content**: privacy policy URL, data safety form, content
   rating, target audience, ads declaration, news declaration.
4. Add the store listing: name `Rounder`, short/full description, screenshots,
   feature graphic, 512 icon.
5. Add a **data deletion** request URL and an in-app deletion path (see
   blockers below).
6. Roll out to production only after the internal test passes on a real device.

## App Store checklist

1. Create the app in App Store Connect with bundle id
   `com.futuretec.rounderapp.sa` and SKU `rounder-resident`.
2. Set the privacy policy URL and support URL.
3. Fill **App Privacy** (phone number, name, photos, approximate location — the
   exact list must match the backend calls).
4. Upload the IPA with Xcode Organizer or Transporter.
5. Fill **App Review Information**: a working demo phone number and a way to
   receive the OTP (or a backend test OTP), because reviewers cannot receive
   your SMS.
6. Add screenshots for the required display sizes, description, keywords,
   category and age rating.
7. Submit with the export-compliance answer already embedded in `Info.plist`
   (`ITSAppUsesNonExemptEncryption=false`).

## Known blockers before submission

These are product/backend items, not build configuration. Both stores may reject
the build while they are open:

- **Account deletion is missing.** The app allows registration/login but has no
  delete-account endpoint or screen. App Store Guideline 5.1.1(v) requires
  in-app account deletion; Google Play requires both an in-app path and a web
  deletion URL. Add the backend endpoint + screen before submitting.
- **Privacy policy and terms labels are not tappable.** `LoginLegalLinks` renders
  plain text and there are no policy URLs. Both stores require a hosted privacy
  policy; App Review may also expect the link to open.
- **Social sign-in is hidden in release builds.** `LoginFormCard` gates the
  Google/Apple buttons with `_socialLoginEnabled = !kReleaseMode` because the
  buttons currently open the OTP result screen without an OAuth SDK. If you
  enable real Google sign-in later, Apple also requires Sign in with Apple.
- **OTP-only login needs reviewer access.** Provide a test phone number and OTP
  path; otherwise App Review cannot get past the login screen.
- **Production API must stay HTTPS.** Release builds disable cleartext traffic;
  the app points at `https://rounder-sa.com/api/v1`.
- **Screenshots and store copy are not in the repo.** They must be produced from
  a real device/release build.

## Release notes

- Android release is minified/shrunk with R8 and Dart obfuscation; keep the
  symbols from every build.
- `android:allowBackup="false"` and `android:usesCleartextTraffic="false"` are
  set in `AndroidManifest.xml` (secure token storage + HTTPS only).
- iOS ships `Runner/PrivacyInfo.xcprivacy` for required-reason APIs.
- iOS display name is `Rounder`; supported localizations are `ar`, `en`, `ur`.
