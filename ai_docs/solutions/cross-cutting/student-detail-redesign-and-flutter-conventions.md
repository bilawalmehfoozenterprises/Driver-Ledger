---
title: Student Detail redesign iteration + Flutter/M3 conventions established
date: 2026-08-17
work_type: refactor
tags: [flutter, material3, ui-design, riverpod, go-router, dot-shorthand]
confidence: high
references:
  - lib/features/students/presentation/views/student_detail_screen.dart
  - lib/features/students/presentation/widgets/this_month_card.dart
  - lib/features/students/presentation/views/payment_history_screen.dart
  - lib/core/router/app_routes.dart
  - AGENTS.md
---

## Summary

Two independent workstreams landed in this session:

1. **Codebase conventions**: migrated to Dart 3.10 dot-shorthand syntax across `lib/` and `test/`, and switched all `go_router` navigation from raw path strings (`context.push('/students/$id')`) to a typed `AppRoutes` enum used with `pushNamed`/`goNamed`.
2. **Student Detail screen redesign**: went through ~6 visual iterations (colored SliverAppBar hero band → avatar → tabs on Students list → flat/tonal cards → back to shadowed `Card`) before landing on a design driven by actual usability feedback: **This Month card first, with Record Payment / Record Vacation / Payment History as three stacked buttons directly on the card**, student info below it, full history moved to its own screen (`PaymentHistoryScreen`) reached via the third button.

The redesign churn was expensive and avoidable in hindsight — see Pitfalls below.

## Reusable Insights

**Dot shorthand rules for this codebase** (now also documented in `AGENTS.md`):
- Applies to enums, named constructors, static members in named-arg / declared-type positions — e.g. `mainAxisAlignment: .center`, `borderRadius: .circular(8)`, `case .morning:` in switch statements.
- Does NOT apply to: `Icons.*` (always errors — `Icons` members don't belong to `IconData`), `const` calls to **unnamed** constructors (`const EdgeInsets.all(16)` stays explicit), values in loosely-typed positions like `expect(actual, SomeEnum.value)` (second arg is `dynamic`), `Type.values[index]` (indexing, not member access), and named-constructor calls passed directly into a broadly-typed slot like `child:`/`floatingActionButton:` (e.g. `ElevatedButton.icon(...)`, `Card.outlined(...)` — context infers `Widget`, not the concrete type).

**Named routing pattern**: `AppRoutes` enum holds both `name` and `path` per route; `GoRoute(path: AppRoutes.x.path, name: AppRoutes.x.name, ...)` in the router, and call sites use `context.pushNamed(AppRoutes.x.name, pathParameters: {...})` instead of string interpolation into a path. Eliminates a whole class of typo bugs and makes route params explicit.

**M3 flat-list guidance actually applies here**: for a scrollable list of homogeneous rows (Students list, month history), M3 recommends flat rows with dividers or tonal fill — NOT `Card`-per-row with a shadow. This was verified via `act-flutter-docs-researcher` + WebSearch against m3.material.io and Flutter's own docs (Context7 MCP is not available in this environment — use `WebSearch`/`WebFetch` + the docs-researcher subagent instead when asked to "check the docs").

**`SliverAppBar` + `FlexibleSpaceBar` is the correct widget for a colored/expanding header** — never hand-roll a `Column` with manual `SafeArea`/`kToolbarHeight` padding to fake a collapsing header; it reliably produces overlap bugs (back button rendering on top of custom content) that `SliverAppBar` avoids by construction.

**`AlertDialog` content is centered by default** — a `Column` inside `content:` needs `crossAxisAlignment: .start` explicitly, or a short label line above a full-width `TextField` will look oddly centered while the field looks left-aligned.

## Decisions

- **Removed the avatar** from the student header entirely (user's call — no profile photo exists in the data model, initials-only avatar wasn't wanted here).
- **Removed the colored hero band and per-status AppBar coloring** — looked visually distinctive but actively hid the primary action (Record Payment) behind a non-obvious "tap the header" gesture. A non-technical user (a driver managing student fee records) needs the action visible immediately, not discoverable.
- **Current month excluded from the "PAST MONTHS" / history list** — the This Month card is the single source of truth for current status; the list only shows history. Avoids restating the same Rs. amount/status twice on one screen (this is an explicit M3/Google content-design principle, not just taste — see the researched note in conversation).
- **Payment History demoted from a full inline section to a button inside the This Month card**, then to its own route/screen (`/students/:id/history` → `PaymentHistoryScreen`). Keeps the primary screen to one task (check + record this month) and pushes secondary browsing to a dedicated page.
- **No tabs on Student Detail** — tabs are for switching between parallel views of the same kind of content (like Active/Inactive on the Students list); Student Detail is a single top-to-bottom task flow, so tabs would hide the action buttons behind a switch instead of reducing friction.

## Pitfalls

- **Redesigning by aesthetic instinct instead of the actual user's workflow wasted several iterations.** The colored-header/avatar/SliverAppBar exploration was visually reasonable but the user (rightly) called it "very bad for non-technical users" — it hid the Record Payment button, the single most important control on the screen, behind a tap-the-status-band gesture with no visual affordance. **Lesson: for a workflow-tool app (not a content/browsing app), always ask "where's the primary action" before doing visual layout work — don't let hierarchy experiments bury it.**
- Building a hand-rolled expanding header (`Column` + manual `SafeArea(bottom: false)` + `Padding` with computed top inset) produced a real overlap bug (back button rendered on top of the avatar/name). `SliverAppBar`/`FlexibleSpaceBar` solves this correctly and should have been reached for immediately instead of after a broken screenshot.
- When the user asks to "research using Context7 MCP" — it is not available in this environment (checked via `ToolSearch`). Fall back to `WebSearch` + `act-flutter-docs-researcher` subagent, and say so rather than silently substituting.

## Validation

`flutter analyze` (0 issues) and `flutter test` (all passing, 15 tests) were run after every structural change in this session. Per `AGENTS.md`'s UI-visual-verification convention (captured separately in project memory, not AGENTS.md itself), analyze/test passing does NOT catch visual/spacing regressions — every layout change in this session was followed by asking the user to hot-reload and confirm the screenshot before proceeding to the next change.

## Follow-ups

- `PaymentHistoryScreen` re-derives past records from `studentDetailNotifierProvider` rather than having its own notifier — fine for now, but if history grows large/paginated this should get its own provider.
- The three-button stack on `ThisMonthCard` (Record Payment / Record Vacation / Payment History) has not been tested with a fully-paid month where Record Payment is disabled — worth a visual check that the disabled button state reads clearly to a non-technical user.
