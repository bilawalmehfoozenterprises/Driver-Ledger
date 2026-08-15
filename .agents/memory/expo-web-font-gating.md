---
name: Expo web font gating
description: Preventing a blank Expo web preview when native font loading does not resolve
---

Keep the native font gate for iOS and Android, but let the web root layout hide the splash and render when `Platform.OS === 'web'`.

**Why:** In this Expo setup, the web preview can remain on the splash surface without reporting a browser error if the native font-loading promise never resolves.

**How to apply:** When using the scaffolded `useFonts` pattern in `src/app/_layout.tsx`, include a web-specific render and splash-hide fallback; do not remove font gating for native platforms.