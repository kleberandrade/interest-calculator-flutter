# Current verification — Flutter 3.50.0

On 17 November 2026, upgraded to Flutter 3.50.0 / Dart 3.14.0 in an isolated SDK copy and migrated the deprecated Material imports/localization to material_ui 1.11.1. All 32 hosted packages in the registry audit match their latest stable versions; two explicit SDK-pin patch overrides are documented in dependencies.md.

- Lockfile enforcement, formatting and analyzer passed.
- All 12 application/domain/widget tests passed, including 360px with 1.5× text.
- The test code extracted from the revised Medium article passed as a separate executable Flutter test. The input-parsing snippet ran with outputs 123456, R$ 1.234,56 and 200.
- The committed tool/lesson_example.dart ran and printed principal R$ 1.000,00, fee R$ 20,00, compound interest R$ 20,10 and total R$ 1.040,10.
- Web release build passed with the full updated dependency graph. Reopened its actual Chrome bundle and confirmed the example; captured a new desktop screenshot and a 390×844 result screenshot under docs/images/.
- Android initially rejected the old Gradle configuration. Updated to the Flutter 3.50 template (Gradle 9.5.0, AGP 9.3.1, Kotlin 2.4.20), preserved the application ID, and built a debug APK successfully with JDK 21. No dependency-validation bypass or SDK-license acceptance was used.
- iOS was not rebuilt in this follow-up. The earlier failures below remain the verified limits; no phone/emulator runtime test is claimed.

## Earlier verification history

The following notes describe the earlier Flutter 3.41.9 modernization, retained for traceability. Its package versions and mobile toolchain are superseded by the current section above.

### Previous environment and limitations

Environment inspected on 17 November 2026: Flutter 3.41.9 stable, Dart 3.11.5, macOS arm64, Chrome, Xcode with iOS Simulator SDK 27.2, and installed Android SDK/JDK 21. The Flutter SDK used for commands was an isolated filesystem clone; the shared SDK was not upgraded or modified.

## Checks performed

- Dependency resolution and lockfile enforcement succeeded. Several SDK-pinned transitive packages have newer versions; overriding SDK constraints would not be an honest toolchain upgrade.
- Formatting check and `flutter analyze` passed.
- `flutter test --coverage`: 12 behavioral tests passed. Domain calculation and parsing each had all executable LCOV lines exercised (49/49 and 23/23). This is line coverage, not branch coverage or proof of correctness.
- `flutter build web --release` succeeded. Its Wasm dry run also succeeded; a Wasm application was not separately built or run. Added the missing official Cupertino icon font after a build warning, then repeated affected checks.
- Actual Chrome interaction: loaded the release bundle from a loopback-only server, enabled Flutter accessibility, used the fictional example, confirmed R$ 1.040,10, rejected a negative amount, observed stale-result removal, reset the fields, switched light/dark themes and inspected a 390×844 viewport. The screenshots in `screenshots/` are real Web captures. Widget tests additionally exercised 360px with 1.5× text.
- Android debug APK build passed with JDK 21. It was not installed or run on a phone/emulator. No SDK license terms were accepted and no store publication or deployment occurred.
- iOS host migrated to the current template, preserving `com.example.interestCalculator`, and raised to iOS 15 after installed Xcode rejected the template's iOS 13 target. The unsigned device build then failed requesting a development team/provisioning profile. A simulator build failed inside Flutter's framework architecture handling (`arm64 x86_64`, despite `lipo` listing both); an explicit arm64 Xcode attempt subsequently failed due to disk exhaustion. No iOS build success or device test is claimed. Recheck on a supported Xcode/runtime combination with sufficient free space; no signing account was altered.

## Resource and quality-tool limits

The disk filled during native builds. Only this project's generated intermediates were removed; the successful Android APK was retained separately under ignored `build/verified-android/`. Tests interrupted by disk exhaustion were rerun after cleanup; interrupted runs are not counted as passing.

Installed `crapper`, `dryer` and `mutator` were invoked against `lib`. They returned “No source files to analyze/mutate”: their installed language support excludes Dart. No CRAP threshold, duplicate similarity or mutation score is asserted. Domain boundaries and independent fixtures are covered by Dart tests, rather than fabricated metrics.

The app has no backend or persistent storage. There is no network calculation, banking integration, external-rate lookup or jurisdiction-specific rule validation. The initial default Flutter Web engine/font resources may require a network connection. Screen-reader semantics and enlarged-layout tests are present, but a full audit with assistive hardware was not performed.
