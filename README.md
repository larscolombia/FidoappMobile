# fido_app_customer

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Versioning & Release Process

App version follows the format MAJOR.MINOR.PATCH+BUILD (Flutter `pubspec.yaml` line `version:`). Example: `1.16.1+16`.

- `MAJOR.MINOR.PATCH` maps to iOS `CFBundleShortVersionString` and Android `versionName`.
- `BUILD` (after +) maps to iOS `CFBundleVersion` and Android `versionCode`.
- Increment the BUILD every release. Increment PATCH/MINOR/MAJOR as needed for fixes, features, or breaking changes.

### Steps to Bump Version
1. Edit `pubspec.yaml`: update `version: x.y.z+n` (ensure `n` strictly increases).
2. Sync Android `android/app/build.gradle` (versionName / versionCode) if not already matching (we keep them aligned manually here).
3. Run `flutter pub get`.
4. (Optional) Commit: `chore(release): bump version to x.y.z+n`.

### iOS Release (IPA)
1. `flutter clean` (optional if build artifacts stale).
2. `flutter build ipa --release`.
3. Upload: use Transporter app (drag the generated `build/ios/ipa/*.ipa`) or `xcrun altool` API key upload.
4. Add release notes in App Store Connect, submit for TestFlight / App Review.

### Android Release (Play Store)
1. Ensure signing config (keystore) is present and not tracked publicly.
2. `flutter build appbundle --release` (AAB) or `flutter build apk --release` for local test.
3. Locate artifact: `build/app/outputs/bundle/release/app-release.aab`.
4. Upload to Play Console (internal track first), add release notes, then promote.

### Notes
- Keep Bundle ID / Application ID unchanged unless coordinating store metadata update.
- Verify push notification / entitlement changes in both stores before submission.
- For hotfix: bump PATCH and BUILD (e.g., 1.16.1+16 -> 1.16.2+17).

Last updated: 2025-08-14.
