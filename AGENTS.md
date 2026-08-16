## ACT Workflow

ACT workflow storage for new Specs is configured in `.act/config.yaml`.

ACT workflow semantics, Workflow Storage selection, artifact vocabulary, and domain-doc guidance are defined in `.act/workflow.md`.

## Dart Dot Shorthand Syntax

This project targets SDK >= 3.10.0-0, which supports dot shorthand syntax. Use it wherever the type is inferable from context:

- **Enums**: `mainAxisAlignment: .center` instead of `mainAxisAlignment: MainAxisAlignment.center`, including in `switch` statement `case` labels (e.g. `case .morning:`).
- **Named constructors**: `borderRadius: .circular(8)` instead of `BorderRadius.circular(8)`, when the parameter type makes the target type unambiguous.
- **Static fields/getters**: `.zero` instead of `EdgeInsets.zero`, when inferable.

**Do not use dot shorthand for:**
- `Icons.*` — always fails, since `Icons` members belong to the `Icons` class, not `IconData` (the inferred type).
- Any position where the context type is a broad interface rather than the concrete declaring type — e.g. a named-constructor call passed directly as `child:`/`floatingActionButton:`/etc. (`ElevatedButton.icon(...)`, `Card.outlined(...)`, `FloatingActionButton.extended(...)`) infers as `Widget`, not the specific class, so shorthand doesn't resolve there. Keep these explicit.
- `const` expressions using an **unnamed** constructor (e.g. `const EdgeInsets.all(16)`, `const Duration(milliseconds: 300)`) — keep the explicit type name. Only **named** constructors in const context get shorthand (e.g. `const .circular(8)`).
- Values passed to loosely-typed APIs like `expect(actual, SomeEnum.value)` in tests — `expect`'s second parameter is `dynamic`, so the type isn't inferable there.
- `Type.values[index]` — this is a static-field access followed by indexing, not a direct member/constructor reference, so shorthand doesn't apply.

When adding new code, prefer dot shorthand in eligible spots by default rather than writing the full type name — don't wait for a follow-up migration pass.
