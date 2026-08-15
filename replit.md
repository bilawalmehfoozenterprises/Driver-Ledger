# Driver Income Tracker

A mobile-only Expo foundation for a Pakistani driver who will later track student transport income, occasional bookings, and vehicle expenses such as petrol.

## Run & Operate

- `pnpm --filter @workspace/driver-income-tracker run dev` — run the Expo mobile preview
- `pnpm --filter @workspace/api-server run dev` — run the shared API server when backend work is introduced
- `pnpm run typecheck` — full typecheck across all packages
- `pnpm run build` — typecheck + build all packages

## Stack

- pnpm workspaces, Node.js 24, TypeScript 5.9
- API: Express 5
- DB: PostgreSQL + Drizzle ORM
- Validation: Zod (`zod/v4`), `drizzle-zod`
- API codegen: Orval (from OpenAPI spec)
- Build: esbuild (CJS bundle)

## Where things live

- `artifacts/driver-income-tracker/src/app` — Expo Router layouts and routes only
- `artifacts/driver-income-tracker/src/components` — shared native components
- `artifacts/driver-income-tracker/src/features` — feature-oriented modules as they are added
- `artifacts/driver-income-tracker/src/theme` — current placeholder theme tokens
- `artifacts/driver-income-tracker/src/hooks` — reusable hooks
- `artifacts/driver-income-tracker/src/services` — future persistence and integrations
- `artifacts/driver-income-tracker/src/types` — shared domain types
- `artifacts/driver-income-tracker/src/utils` — small reusable helpers

## Architecture decisions

- Expo Router uses the recommended `src/app` structure.
- The initial app is frontend-only; there is no app backend, database, or authentication layer yet.
- Bottom navigation supports Expo Router NativeTabs on supported iOS versions and a classic tabs fallback elsewhere.
- `lucide-react-native` is the app icon library for custom UI icons.

## Product

The current foundation exposes empty Home, Reports, and Settings routes. Income, expenses, persistence, and the central Add interaction are intentionally deferred.

## User preferences

- Establish the theme and navigation direction before designing the Add interaction.
- Keep the first foundation free of mock data, business logic, backend work, and authentication.

## Gotchas

- Add routes only under `src/app`; non-route code belongs under the corresponding `src/` folder.
- Keep the static `app.json` configuration; do not add a dynamic Expo config file.

## Pointers

- See the `pnpm-workspace` skill for workspace structure, TypeScript setup, and package details
