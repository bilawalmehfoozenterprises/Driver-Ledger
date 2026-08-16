# Driver Ledger

Driver Ledger helps drivers who transport students on a recurring monthly
basis track fees, vacation deductions, and payment status — per student, per
month.

If you drive kids to school and manage payments in a notebook or a spreadsheet,
this app is meant to replace that: add a student, set their monthly fee, log
vacation days, and see who still owes for the month.

## Status

Early-stage. The `students` feature (add/edit/list students, monthly records,
payment tracking) is in progress. See open [issues](../../issues) for what's
planned.

## Tech stack

- [Flutter](https://flutter.dev) / Dart (SDK `^3.12.2`, uses
  [dot shorthand syntax](https://dart.dev/language))
- [Riverpod](https://riverpod.dev) (with code generation) for state management
- [go_router](https://pub.dev/packages/go_router) for navigation
- [sqflite](https://pub.dev/packages/sqflite) for local SQLite storage

## Getting started

1. Install [Flutter](https://docs.flutter.dev/get-started/install) (this
   project targets the stable channel).
2. Install dependencies:
   ```
   flutter pub get
   ```
3. Run the app on a connected device or simulator (Android and iOS are
   supported):
   ```
   flutter run
   ```

## Running tests and lint

```
flutter test
flutter analyze
```

Both must pass with zero errors before submitting a pull request.

## Terminology

This project uses precise, domain-specific terms (e.g. "Student", "Monthly
Fee", "Vacation Days", "Payment Status") consistently across code and docs.
See [GLOSSARY.md](GLOSSARY.md) before naming anything new.

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for
setup, coding style, and how to submit a pull request. This project follows a
[Code of Conduct](CODE_OF_CONDUCT.md).

## License

[MIT](LICENSE)
