# ADR-001: Dual-Host API Architecture

> Copy this template and assign a sequential number, e.g., `ADR-001_my-decision.md`.
> Naming regex: `^ADR-\d{3}_[a-z0-9-]+\.md$`

| Field         | Value                                                    |
| ------------- | -------------------------------------------------------- |
| Decision Date | 2026-04-24                                               |
| Status        | Accepted                                                 |
| Related       | SA-001_system-overview.md, SPEC-001_api-auth-and-rbac.md |
| Impact Scope  | All Controllers, auth chain, deployment pipeline         |

## Context

The booking system serves two distinct audiences: **operators** (venue staff, admins) and **end users** (ticket buyers). These audiences have different authentication requirements, different exposure surface areas, and different risk profiles.

We needed to decide whether to serve both in a single ASP.NET Core host or split them into two separate deployable hosts.

## Options Considered

### Option A — Single Host with Route-Based Separation

All endpoints live under one ASP.NET Core application. Admin endpoints are protected by a stricter `[Authorize(Roles = "Admin")]` policy; EndUser endpoints use standard JWT.

- **Pros**: Simpler deployment (one container), single pipeline, no shared-library overhead.
- **Cons**: A misconfigured route or policy could accidentally expose admin endpoints to end users. Blast radius of a vulnerability is larger. Scaling admin and public traffic together wastes resources.

### Option B — Dual Host Sharing a Service Layer

`Booking.Api.Admin` and `Booking.Api.EndUser` are two separate ASP.NET Core projects. Both reference `Booking.Service` as a shared class library. They are deployed and scaled independently.

- **Pros**: Clear trust boundary — admin surface is never exposed to the public internet. Independent scaling. Auth middleware per host can be tuned separately. Easier to audit.
- **Cons**: Two deployment artifacts; CI pipeline needs to handle both. Shared `Booking.Service` must avoid host-specific assumptions.

## Decision

**Chose Option B — Dual Host.**

The security boundary is the decisive factor. Exposing admin operations in the same process as public traffic carries unacceptable risk at event scale. The added deployment complexity is manageable with a straightforward GitHub Actions matrix build.

## Consequences

- **Positive**: Admin API can be placed on an internal VNET with no public DNS; EndUser API sits behind a CDN/WAF.
- **Positive**: Auth middleware can enforce stricter token policies (shorter TTL, IP binding) for Admin without affecting EndUser.
- **Negative**: `Booking.Service` must remain host-agnostic — no `IHttpContextAccessor` or host-specific DI registration in the shared layer.
- **Follow-up**: Document allowed and prohibited dependencies for `Booking.Service` in Code Generation Rules (see `AGENTS.md`).
