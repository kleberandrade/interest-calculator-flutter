# Dependency audit — 17 November 2026

Verified toolchain: Flutter 3.50.0 stable / Dart 3.14.0. Updated all direct constraints and refreshed the complete transitive dependency graph. The shared Flutter SDK was not changed.

## Result and explicit overrides

The all-versions report compares 32 hosted packages with their current stable releases: every installed version matches latest. `flutter pub outdated --json` returns an empty package list. This is a dated registry audit, not a promise that later releases will be compatible. See [all versions](dependency-audit/all-versions.json), [resolved graph](dependency-audit/resolved.json), and [outdated result](dependency-audit/outdated.json).

Flutter 3.50.0 still pins `material_color_utilities` 0.13.0 and `test_api` 0.7.14. This project explicitly overrides those two pins to stable patch versions 0.13.1 and 0.7.15, respectively, to complete the requested update. Analyzer, application tests, the executable article test, Web release and Android debug build passed with these overrides. This does not certify the entire Flutter SDK or unrelated applications. Remove the overrides when Flutter adopts those releases, then rerun the checks. The [report before overrides](dependency-audit/sdk-pins-before-overrides.json) records why they were necessary.

## Complete resolved graph

Direct, development and transitive packages follow. Internal SDK packages may report 0.0.0; their implementation follows Flutter 3.50.0. Hosted package hashes are pinned in pubspec.lock.

- `async` 2.13.1 — transitive; hosted
- `boolean_selector` 2.1.2 — transitive; hosted
- `characters` 1.4.1 — transitive; hosted
- `clock` 1.1.3 — transitive; hosted
- `collection` 1.19.1 — transitive; hosted
- `cupertino_icons` 2.0.0 — direct; hosted
- `cupertino_ui` 1.1.7 — transitive; hosted
- `fake_async` 1.3.3 — transitive; hosted
- `flutter` 0.0.0 — direct; sdk
- `flutter_lints` 6.0.0 — dev; hosted
- `flutter_localizations` 0.0.0 — direct; sdk
- `flutter_test` 0.0.0 — dev; sdk
- `interest_calculator` 2.0.0+2 — root; root
- `intl` 0.20.3 — transitive; hosted
- `leak_tracker` 11.0.2 — transitive; hosted
- `leak_tracker_flutter_testing` 3.0.10 — transitive; hosted
- `leak_tracker_testing` 3.0.2 — transitive; hosted
- `lints` 6.1.0 — transitive; hosted
- `listen` 1.0.1 — transitive; hosted
- `matcher` 0.12.20 — transitive; hosted
- `material_color_utilities` 0.13.1 — transitive; hosted
- `material_ui` 1.11.1 — direct; hosted
- `meta` 1.19.0 — transitive; hosted
- `path` 1.9.1 — transitive; hosted
- `sky_engine` 0.0.0 — transitive; sdk
- `source_span` 1.10.2 — transitive; hosted
- `stack_trace` 1.12.2 — transitive; hosted
- `stream_channel` 2.1.4 — transitive; hosted
- `string_scanner` 1.4.1 — transitive; hosted
- `term_glyph` 1.2.2 — transitive; hosted
- `test_api` 0.7.15 — transitive; hosted
- `vector_math` 2.4.4 — transitive; hosted
- `vm_service` 15.4.0 — transitive; hosted
