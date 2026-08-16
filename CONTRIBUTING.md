# Contributing to Driver Ledger

Thanks for your interest in contributing! This guide covers setup, coding
style, and how to submit changes.

## Setup

1. Install [Flutter](https://docs.flutter.dev/get-started/install) (stable
   channel).
2. Clone the repo and install dependencies:
   ```
   flutter pub get
   ```
3. Run the app (Android or iOS device/simulator):
   ```
   flutter run
   ```

## Before you submit a pull request

Every file you touch or create must pass, with zero errors:

```
flutter analyze
flutter test
```

Fix lint and type errors as you go — don't leave them for review.

## Coding style

- Follow existing patterns in `lib/` (feature-based folders under
  `lib/features/<feature>/data` and `lib/features/<feature>/presentation`).
- Use [Riverpod code generation](https://riverpod.dev/docs/concepts/about_code_generation)
  for new providers/notifiers, matching the style in `lib/features/students`.
- This project targets Dart SDK `^3.12.2` and uses
  [dot shorthand syntax](https://dart.dev/language) (e.g. `.center` instead of
  `MainAxisAlignment.center`) wherever the type is inferable from context.
  See `AGENTS.md` for the full rules and exceptions.
- Use the terms defined in [GLOSSARY.md](GLOSSARY.md) consistently (e.g.
  "Student", "Monthly Record", "Vacation Days"). If you need a new
  domain term, add it to the glossary in the same PR.

## Tests

New features and bug fixes should include tests. Look at
`test/features/students/` for the existing pattern: fake repositories +
notifier tests.

## Submitting a pull request

1. Fork the repo and create a branch from `main`.
2. Make your changes, with tests, following the style above.
3. Make sure `flutter analyze` and `flutter test` both pass.
4. Open a pull request describing what changed and why. Link any related
   issue.
5. Be responsive to review feedback — small, focused PRs are easier to review
   and merge quickly.

## Reporting bugs / requesting features

Please use the GitHub issue templates (bug report or feature request) so we
have the context needed to act on it.

## Code of Conduct

This project follows the [Code of Conduct](CODE_OF_CONDUCT.md). Please read
it before participating.
