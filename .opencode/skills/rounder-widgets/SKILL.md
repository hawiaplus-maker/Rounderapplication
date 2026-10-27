---
name: rounder-widgets
description: Screen-composition and widget-extraction rule for the Rounder Flutter app (package rounder_application). A screen file is a skeleton — every primary section and every private widget-builder helper (`Widget _buildX()`, `Widget _x()`, top-level `Widget _x(...)` in a screen file) must live as its own widget class in its own file inside that feature's widgets folder (`presentation/view/widget/`). Use this skill whenever you create, edit, split or review ANY Flutter screen or widget in this repo — new screens, adding/removing a section, extracting helpers from legacy screens, cleaning a long build method, or when the user says "افصل الودجت", "اعمل widget", "الشاشة كبيرة", "قسم في ملف", "split this screen", "move _buildX to a widget" — even if the task is described as small. Also load it before starting a refactor that replaces builder methods with widget classes.
---

# Rounder Screen Composition — Builders Never Live in Screens

The hard rule: **a screen file contains no layout business of its own.** It wires
`Scaffold`/`SafeArea`/app bar, owns the state/controllers, and calls one widget per
primary section. Every `Widget _something(...)` method that returns UI — in a
screen file, at class level or top-level — is a widget that belongs in its own
file under the feature's widgets folder.

Why: screens stay readable (a reviewer can name every section by reading the
composition), widgets get `const` constructors and rebuild in isolation, and
merge conflicts shrink. A `_buildHeader()` helper ties its subtree to the
screen's rebuild and is invisible to the rest of the feature.

## 1. Where extracted widgets land

```
lib/layout/<role>/features/<feature>/
├── presentation/
│   └── view/
│       ├── screens/<name>_page.dart      # skeleton only — calls widgets below
│       └── widget/<name>.dart            # every extracted section/widget
├── data/ …
```

- Pages/screens/flows → `presentation/view/screens/` (rounder-screens).
- Section widgets → `presentation/view/widget/`.
- Flow screens already under `execution/<flow>/` → `execution/<flow>/presentation/widget/` (match the neighbours, don't move existing files to a new shape).
- Cross-feature reusable pieces → `lib/layout/global/widgets/` (create only when genuinely shared by 2+ features).
- Do not create `widgets/`, `widgets.dart`, or a single barrel file; one widget class per file, snake_case file name.

Live examples already in the repo — follow their shape:
`dashboard/presentation/view/widget/` (home_hero_section, home_summary_cards,
home_health_card, resident_dock, …), `units/presentation/view/widget/`,
`post_service/presentation/view/widget/`, `onboarding/presentation/view/widget/`.

## 2. What may stay in the screen file

- `Scaffold`, `SafeArea`, background decoration, app bar wiring.
- The section list (`Column`/`ListView` of widget invocations) and spacing (`SizedBox`/`Gap`).
- State fields/controllers and their `initState`/`dispose`.
- Short glue: `BlocBuilder`/`BlocListener` wiring that maps state → which section widget shows, and navigation callbacks passed into widgets.
- An inline one-off wrapper like a `Divider` or an `Icon`.

Everything a reviewer would name as a section (header, hero, card list, form group,
panel, footer action bar, empty state, result view, step body…), plus any
`Widget _x(...)` helper that renders more than that, becomes a widget class in
its own file.

## 3. How to extract (procedure)

1. Read the whole screen file before touching it; list every `Widget _...(` method
   (grep `Widget _` catches class-level and top-level helpers).
2. Name the sections first (UX names: "union header", "account profile", "review
   step"), then map each builder — including shared helpers like `_panel`,
   `_subPage`, `_action` — to a section or a small reusable widget file.
3. Create the widget file as a `StatelessWidget` (or `StatefulWidget` when it
   owns controllers/animation — then keep its state class private in that file).
4. Constructor: `super.key` + **required named params for exactly the data it
   renders**, and callbacks for every action (`required this.onTap`). No passing
   the whole cubit/state through; if a section needs a cubit, it reads its own
   via `context.watch`/`context.read` like the neighbours do.
5. Replace the call site in the screen with one invocation, delete the helper
   method, and repeat. Do it section by section — the app must still analyze
   after each batch, so a broken extraction is easy to spot.
6. `flutter analyze` must stay at zero new issues. Do not rename or re-style
   unrelated code while extracting; the refactor is behavior-preserving.

Small atoms used only by one extracted widget (a pill, a mini row, a divider
decoration) stay private **inside that widget's file** as private widget classes
(`class _Pill extends StatelessWidget`) — not as `Widget _pill()` methods. Extract
a shared atom to its own file only when two or more widgets use it.

## 4. Naming

- File: `snake_case.dart`, named for the section (`account_profile_section.dart`,
  `union_header_widget.dart`, `order_details_panel.dart`).
- Class: `<Noun>Widget` or `<Noun>Section` — match the feature's existing habit.
- No `_buildX`, `_widget`, `_part` files. Private classes only inside their file.

## 5. Visual/theme rules inside extracted widgets

- Colors only from `AppColors`/`Theme` (`lib/core/theme/app_theme.dart`); no raw
  `Color(0x...)` or `Colors.x` in new/extracted UI.
- Every user-visible string is `AppLocaleKey.x.tr()` — add keys to
  `app_locale_key.dart` + `assets/i18n/{en,ar,ur}.json` when missing. No
  hardcoded Arabic/English text in the extracted widget.
- Direction-safe layout: `TextAlign.start/end`, `AlignmentDirectional`,
  `EdgeInsetsDirectional`; wrap texts in `Row` with `Expanded`/`Flexible`.
- Keep constructors `const` where the widget allows it.

## 6. Review checklist (run before claiming done)

1. `grep -rn "Widget _" <screens folder>` → no widget-builder methods in screen files (state setters that return void are fine).
2. Every extracted class has its own file, imports only what it uses, and is invoked exactly once per section occurrence (list items: once, instantiated per item).
3. No behavior change: keys preserved (`ValueKey('account-profile')` etc.), callbacks still wired.
4. `flutter analyze` clean; screen file reads as a table of contents.

## Related skills

- `rounder-screens` — which files are pages and why they live in
  `presentation/view/screens/`; this skill governs what goes inside them.
- `rounder-logic` — pure helpers live in the app-level `lib/logic/`, never in
  widgets.
- `flutter` — general Flutter rules and finish line (analyze/format/tests).
- Project UI conventions: `AppColors`/`AppTheme`, `AppLocaleKey`, `AppImages` — read the actual files in `lib/core/` before inventing a token.
- `figma-mcp-to-code` — when the sections come from a Figma design, pull each section with `get_design_context` and land it in its widget file directly (don't dump it into the screen).
