---
name: Workspace package installs
description: How to add dependencies to a package when the generic installer targets the workspace root
---

Use a package-scoped pnpm command for dependencies that belong to one workspace package:
`pnpm --filter @workspace/<package> add <dependency>`.

**Why:** The generic language-package installer can fall back to `pnpm add` at the monorepo root and fail the workspace-root safety check instead of updating the intended package.

**How to apply:** Use the package filter for artifact-specific Expo, web, or server dependencies; keep root installs limited to true workspace-wide tooling.