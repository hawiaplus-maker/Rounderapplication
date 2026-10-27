---
name: rounder-screens
description: Page-placement rule for the Rounder Flutter app (package rounder_application) — every page/screen file lives in the feature's screens folder (`lib/layout/<role>/features/<feature>/presentation/view/screens/`), including flow/container pages that compose section widgets AND other pages/screens of the same feature (`account_flow.dart`, `resident_home_screen.dart`). `widget/` is only for sections/atoms/dialogs — never pages. ALWAYS use when creating, editing, moving or reviewing ANY page, screen, flow, tab or sub-page in this repo, when deciding where a page file belongs, or when the user says "صفحة", "شاشة", "شاشة جديدة", "page", "screen", "flow", "screens folder", "الصفحة في فولدر الودجت", "افصل الصفحات", "account flow" — even if the task is described as small. Pairs with rounder-widgets (what goes inside the page) and rounder-logic (where the logic lives).
---

# Rounder Screens — Pages Live in the Feature's `screens/` Folder

The hard rule: **a file that is a page lives in the feature's screens folder.**
A page is any widget that renders a whole page — a `Scaffold`/page shell with a
header/body/footer, a tab body, a step page, or a **flow/container page that
composes other pages and section widgets of the same feature**. Pages never
live in `widget/`, never at the feature root, and never share a file with a
section.

Why: the folder tells you the role at a glance. A reviewer looking for "the
account profile page" opens `screens/`; a reviewer looking for "the balance
card" opens `widget/`. Flow pages compose other pages — they are the map of a
feature, not a reusable piece.

## 1. Where pages land

```
lib/layout/<role>/features/<feature>/
├── presentation/
│   └── view/
│       ├── screens/                 # ← pages: *_page.dart, *_screen.dart, *_flow.dart
│       ├── widget/                  # sections/atoms: *_card.dart, *_panel.dart, *_header.dart,
│       │                            #   *_dialog.dart, *_bar.dart, *_tile.dart, *_button.dart
│       └── style/                   # feature layout/text tokens (optional)
├── data/                            # models + repos
├── validation/                      # form validators (rounder-validation)
└── …
lib/logic/                           # all pure logic (rounder-logic), app-level
```

Live examples already in the repo — follow their shape:

- `account/presentation/view/screens/`: `account_flow.dart` (composes the
  profile, edit, settings, notifications, privacy, help and gifts pages),
  `account_profile_page.dart`, `account_edit_page.dart`, `account_sub_page.dart`, …
- `dashboard/presentation/view/screens/resident_home_screen.dart`: the resident
  tab shell that composes the dashboard body and four feature pages.
- `bookings/presentation/view/screens/order_details_screen.dart`,
  `services/presentation/view/screens/service_journey_screen.dart`, …

## 2. Page vs widget (decision table)

| File renders | Folder | Example |
|---|---|---|
| A whole page (page shell + sections; a tab; a step; a result page) | `screens/` | `account_profile_page.dart` |
| A flow/container page that switches between other pages of the feature | `screens/` | `account_flow.dart`, `resident_home_screen.dart` |
| A section of a page (header, hero, panel, card, list item, form group, action bar, empty state) | `widget/` | `account_header.dart`, `account_panel.dart`, `home_hero_section.dart` |
| A dialog / bottom sheet / snack content | `widget/` | `discard_profile_dialog.dart`, `sign_out_dialog.dart` |
| A sub-page shell reused by several feature pages (back bar + scroll body) | `screens/` | `account_sub_page.dart` |

Rules of thumb:

- Named `*_page.dart`, `*_screen.dart` or `*_flow.dart` → `screens/`.
- Named `*_card.dart`, `*_panel.dart`, `*_tile.dart`, `*_bar.dart`,
  `*_header.dart`, `*_dialog.dart`, `*_button.dart`, `*_input.dart` → `widget/`.
- A page that receives controllers/callbacks from a flow and renders the page
  body is still a page — it belongs to `screens/`, not `widget/`, even if it is
  stateless and short.

## 3. Flow pages (containers)

- A flow page owns the local page state (`enum _Page`, `_tab`, controllers,
  `AnimatedSwitcher`/`IndexedStack`) and routes between the feature's pages.
  Keep that wiring in the page itself — it is navigation glue, not a widget.
- Pass small props into the child pages (data + callbacks); never pass the
  flow's `State` or a whole cubit when the child can read its own.
- Cross-feature destinations stay navigation calls (`NavigatorMethods.pushNamed`
  / `MaterialPageRoute` per the feature's existing habit), not page composition.

## 4. One page per file

- One page class per file, `snake_case` file name matching the class
  (`account_profile_page.dart` → `AccountProfilePage`).
- No `Widget _buildX()` / `Widget _section()` methods in the page —
  sections go to `widget/` files (rounder-widgets).
- The page composes its sections: `Scaffold` → header → body sections →
  action bar, one invocation per section, spacing between them.
- No logic inside the page: validation in `validation/`, computations in
  `lib/logic/` (rounder-logic), API in the repo/cubit (petromin-arch shapes).

## 5. Migration / touching an existing feature

- The repo's pages are already under `presentation/view/screens/`; do **not**
  create a second `presentation/view/screen/` (singular) folder or keep new
  pages in `widget/`.
- When moving a page, `git mv` it, update every import (package-absolute
  imports make this mechanical), then `flutter analyze` before continuing.
- Do not mass-rename unrelated features while working on a page; move the
  pages of the feature you are already touching.

## 6. Review checklist (run before claiming done)

1. Every `*_page.dart` / `*_screen.dart` / `*_flow.dart` in the touched feature
   sits in `presentation/view/screens/` — `grep -rn "Widget _build"` in that
   folder returns nothing.
2. `widget/` contains no page files (no `*_page.dart`, `*_screen.dart`,
   `*_flow.dart`) and no `Scaffold`-owning widget.
3. Imports updated everywhere (`grep -rn "presentation/view/screen/" lib` → no
   matches) and `flutter analyze` is clean.
4. Strings use `AppLocaleKey`, colors `AppColors`, layout direction-safe
   (`AlignmentDirectional`/`EdgeInsetsDirectional`).

## Related skills

- `rounder-widgets` — what goes inside the page (sections in `widget/` files, no
  builder methods).
- `rounder-logic` — all pure logic in `lib/logic/`.
- `rounder-validation` — form validators in the feature's `validation/`.
- `rounder-shared-widgets` — where a section used by 2+ screens lives.
- `petromin-arch` — data/repo/cubit shapes the page consumes.
