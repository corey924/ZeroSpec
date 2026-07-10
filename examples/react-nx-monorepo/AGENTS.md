# AGENTS.md — inventory-frontend AI Navigation Guide

> Primary entry point for GenAI Agents. Read before starting any task.

## Project Summary

**Smart Warehouse Web Frontend** — SPA management interface and Express BFF, consuming inventory-api-hub REST API.

- **Tech Stack**: React 19 + TypeScript 5.8 + Nx 19 Monorepo + Ant Design 5
- **Alias Mapping**: `@frontend/*` → `libs/frontend/*/src/` (follow `tsconfig.base.json`)
- **Architecture**: SPA (Single Page Application) + BFF (Backend for Frontend)
- **Deployment**: Azure App Service (Docker container)
- **Version source of truth**: packages per `package.json`, `nx.json`, `tsconfig.base.json`

## Quick Constraints

1. State management: Zustand (global) / React Context (page) / React Query (server) — MUST NOT use Redux or MobX
2. Styles: styled-components only — MUST NOT write inline styles or use CSS Modules
3. Protected pages MUST configure `permissionKeys`

## Domain-to-Code Map

| Business Domain      | Page Module            | API Hooks            |
| -------------------- | ---------------------- | -------------------- |
| Auth                 | `auth/`                | `auth-hooks.ts`      |
| Inventory Management | `inventory-mngt-page/` | `inventory-hooks.ts` |
| Device Management    | `device-mngt-page/`    | `device-hooks.ts`    |
| Reporting            | `report-page/`         | `report-hooks.ts`    |

## Nx Workspace Structure

```
inventory-frontend/
├── apps/
│   ├── frontend/       ← React 19 SPA (:3000)
│   └── backend/        ← Express BFF (:3333 dev / :3000 prod)
├── libs/
│   ├── frontend/
│   │   ├── components/ ← @frontend/components — shared UI library
│   │   ├── pages/      ← @frontend/pages — page modules
│   │   ├── routes/     ← @frontend/routes — routing and guards
│   │   └── supports/   ← @frontend/supports — API hooks / Store / Theme
│   └── devkit/         ← Nx custom generators
└── types/              ← global type definitions
```

## Code Generation Rules

### API Hook Rules

- React Query v5: `useQuery()` for reads / `useMutation()` for writes
- HTTP client: Axios (baseURL `/api`, proxied via BFF)
- File naming: `{domain}-hooks.ts`

### State Management

- **Global state**: Zustand + Immer — auth / user / routing only
- **Page state**: React Context — each page's `context.tsx`
- **Server state**: React Query — data fetching and caching
- MUST NOT use Redux, MobX, or other state management libraries

### Styling Rules

- Use styled-components for all component styles
- MUST NOT write inline styles or use CSS Modules

### Routing and Permissions

- Route definitions in `libs/frontend/routes/src/configs/route-config.tsx`
- Protected pages MUST configure `permissionKeys` array

## GenAI Documentation Navigation

| What you want to do            | Read this first                    |
| ------------------------------ | ---------------------------------- |
| Understand system architecture | docs/analysis/SA-001               |
| Find available UI components   | docs/components/COMPONENT-INDEX.md |
| Look up architecture decisions | docs/adr/                          |
| Understand Nx workspace config | nx.json                            |

## Common Commands

| Command                 | Description                        |
| ----------------------- | ---------------------------------- |
| `npx nx serve frontend` | Start React SPA dev server (:3000) |
| `npx nx serve backend`  | Start Express BFF (:3333)          |
| `npx nx build frontend` | Build frontend                     |
| `npx nx test frontend`  | Run frontend unit tests            |

## Related Projects

| Project             | Relationship | Notes                           |
| ------------------- | ------------ | ------------------------------- |
| `inventory-api-hub` | API Provider | .NET backend providing REST API |

## Documentation Maintenance Reminders

- **BFF route or API hook change**: apply Contract Ownership; update an in-scope narrative SPEC and Changelog when required, otherwise state why the machine contract or no narrative update is sufficient
- **Add or remove shared component**: update `docs/components/COMPONENT-INDEX.md`
- **Architecture decision**: write new ADR
- Docs governance rules: `docs/README.md`

## Post-Edit Self-Check

Before declaring work complete:
1. List changed files from the current diff.
2. Cross-reference every changed file with the Code-to-Docs Map above.
3. For each candidate doc, state `Update needed` or `No update needed` with a reason.
4. Apply Contract Ownership: update an in-scope narrative SPEC when required; otherwise state why the machine contract or no document update is sufficient.
5. Run `npx nx affected --target=test` to confirm no regressions.

**Forcing Function**: AI agents MUST append a `### Docs Impact` block at the end of any response containing code changes, listing: (a) affected `docs/spec/` files and their update status; (b) reason if no update is needed.
