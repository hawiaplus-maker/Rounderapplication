---
name: rounder-shared-widgets
description: Shared-widget reuse and promotion rule for the Rounder Flutter app (package rounder_application) — a widget used by more than one screen must exist ONCE as its own widget class in its own file (feature-shared → the feature's `presentation/view/widget/`; used by 2+ features → promoted to `lib/layout/global/widgets/`), never copy-pasted between screens and never merged into a barrel or dump file. ALWAYS use when adding a section/widget a second consumer already renders, when duplicating a card/button/pill/gradient/backdrop/header between screens, when deciding where a reusable piece lives ("بيعمل كوبه من الودجت", "نفس المربع مكرر", "shared widget", "استخدمه في شاشة تانية", "promote"), and before creating any widget you suspect another screen needs — pairs with rounder-widgets (the file-split rule) and rounder-logic/validation (the other feature-home rules).
---

# Rounder Shared Widgets — Used Twice Means Written Once

The hard rule: **the second consumer promotes, it never copies.** The moment a
second screen needs a widget, the code that exists in only one file becomes the
shared single source of truth — edits at the shared class reach every consumer.

## 1. Where shared widgets land

| Reach | Home |
|---|---|
| Used by 2+ screens of the SAME feature | `<feature>/presentation/view/widget/` (create the file when the widget stops being screen-private) |
| Used by 2+ features | `lib/layout/global/widgets/<noun>_widget.dart` |
| Used by exactly one screen | stays with its screen file (rounder-widgets split rules) |

- No `widgets.dart`, no barrels, no `shared_widget.dart` dumping ground — one
  widget class per file, snake_case, named for the section it renders.
- Live example in this repo: `lib/layout/global/features/auth/presentation/view/widget/auth_gradient_backdrop.dart`
  — the brand gradient `login`/`register` share (and `otp_flow` uses with its
  own stop values); before extraction it existed as three copy-pasted
  `DecoratedBox` literals.

## 2. The promotion test

Before writing any container/styling block in a screen, ask:

1. Does another screen in this feature render the same block? → extract into
   the feature's widget folder and consume it from BOTH screens.
2. Does another FEATURE need it? → `lib/layout/global/widgets/`, with no
   feature-specific imports leaking into the global file (global widgets take
   everything as constructor params: colors, callbacks, content).
3. Only the copy "mostly matches" (one padding off)? → parameterize the shared
   widget (optional named params) instead of forking it — forks rot faster
   than diffs merge.

## 3. Shape rules for shared widgets

- `StatelessWidget` with `const` constructors whenever possible; state only in
  genuinely stateful pieces.
- Required named params for the data it renders; callbacks in, no cubit
  reach-ins out of folder scope.
- Nothing feature-coupled in global widgets: no `AppLocaleKey` keys that only
  one feature defines, no routes from a specific screen.
- Feature-shared widgets may read their feature's cubit (`context.watch`)
  or stay presentational — match the neighbors in the same folder.

## 4. What this skill does NOT replace

- `rounder-widgets` governs WHICH blocks are extracted and the screen-skim
  composition; this skill only governs WHERE a widget lives once it is shared
  and how promotion happens.
- Do not retrofit grand-fathered legacy screens by force: when a legacy screen
  contains a copy of an existing shared widget, replace it only when you are
  already editing that screen (minimal-diff rule).

## Related skills

- `rounder-widgets` — the extraction/split rule; shared homes are a subset case.
- `rounder-logic` / `rounder-validation` — the same one-home principle applied
  to pure helpers and validators.
- `petromin-ui` — visual tokens inside every shared widget.
