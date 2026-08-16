---
title: Material 3 form improvements, mock data, and safe SQLite migrations
date: 2026-08-16
work_type: feature
tags: [flutter, material-3, faker, sqlite, migrations]
confidence: high
references: [lib/features/students/presentation/views/add_student_screen.dart, lib/core/database/database_helper.dart, pubspec.yaml, test/widget_test.dart]
---

## Summary

The student form was improved using current Flutter Material 3 components instead of custom controls. A mock-data action was added to the app bar to prefill, but not save, realistic fake student details. Parent name and phone were made optional across the form, model, displays, and database schema.

The SQLite migration was also made compatible with databases created by the earlier implementation, where the fee column was named `current_fee` instead of `monthly_fee`.

## Reusable Insights

- In current Flutter, `FilledButton`, `SegmentedButton`, `Card.outlined`, `ListTile`, `TextFormField`, and `showDatePicker` are valid Material 3 APIs. There is no Flutter `PrimaryButton` replacement widget; primary is a style/color role.
- Prefer built-in Material components for form structure: use `SegmentedButton` for a small fixed choice such as the three shifts, and use an outlined `Card` with `ListTile` for a tappable date row.
- A mock action should prefill controllers and local selection state only. It should never call the save path automatically. Show a short snackbar so the user knows the form was changed.
- `faker_dart` can generate names and addresses. Its phone formatter accepts a custom pattern, so `03#########` produces a Pakistan-shaped test number while still using the package for generation.
- When a persisted field becomes optional, update every layer: nullable Dart model fields, empty-string-to-null conversion, nullable SQL columns, and fallback display text such as `Not provided`.
- Existing local SQLite files can outlive the code that created them. A migration must not assume the latest version-1 column names. Inspect `PRAGMA table_info(students)` and choose compatible source expressions before rebuilding the table.
- For old schemas, copy legacy data into the new table using explicit expressions: map `current_fee` to the new fee field, and use `NULL` or `created_at` for columns that did not exist before.
- Flutter widget tests that touch `sqflite` need a test database factory. Add `sqflite_common_ffi` as a dev dependency and set `databaseFactory = databaseFactoryFfi` before tests run.

## Validation

- `flutter analyze`
- `flutter test`
- `dart format`
- Dart MCP file analysis

All checks passed after the form, mock-data action, optional parent fields, and migration fixes.

## References

- Official Flutter Material 3 documentation was checked for the current button, segmented control, form, and menu APIs.
- `faker_dart` package APIs were checked through Dart MCP before use.
