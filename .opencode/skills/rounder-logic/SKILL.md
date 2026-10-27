---
name: rounder-logic
description: Logic-file rule for the Rounder Flutter app (package rounder_application) — ALL pure, reusable computation helpers of the app live in the app-level logic folder (`lib/logic/<name>_logic.dart`), as top-level pure functions, never as one-off private methods hiding inside screens/cubits/widgets, never inside a feature folder, and never copy-pasted between files. ALWAYS use when you create, edit or review ANY logic in a Rounder feature — normalizing or deriving values (phone → 05…), formatting domain data, date/duration math, parsing helpers, computations shared by a cubit and its screen, or when the user says "اللوجيك", "افصل المنطق", "logic file", "helper function", "حط الفانكشن دي في logic folder" — even for a "small" helper. NOT for form validators (rounder-validation), NOT for widgets (rounder-widgets/rounder-screens), NOT for cubit state emission or repository API calls (petromin-arch patterns stay in cubit/repo files).
---

# Rounder Logic — Pure Helpers Live in the App-Level `logic/` Folder

The hard rule: **a screen, cubit or widget never hides a reusable computation**
as a private method or inline expression that another file would have to
copy. Pure logic — deriving, normalizing, formatting and computing values
without touching widgets or `emit()` — lives in one place at the app level:

```
lib/
├── logic/                     # ← ALL pure, side-effect-free functions
│   └── <domain>_logic.dart    # one file per cohesive helper group
├── core/                      # network, theme, locale, services (no logic helpers)
└── layout/
    └── <role>/features/<feature>/
        ├── data/              # models + repos (petromin-arch shapes)
        ├── validation/        # form validators only (rounder-validation)
        └── presentation/      # cubits, screens, widgets (no logic helpers)
```

Live example in this repo: `lib/logic/phone_number_logic.dart`
(`normalizeSaudiLocalMobile`, `saudiLocalMobileAllows`), imported by the login
screen and the phone entry widget instead of an inline `'0$digits'` expression.

## 1. What belongs in `lib/logic/`

- Normalization/derivation of domain values: `normalizeSaudiLocalMobile('0512345678')`.
- Formatting of domain values the repo sends or shows as data (locale-aware
  number/duration/unit formatting that a screen would otherwise repeat).
- Date/duration/size math that several call sites repeat.
- Small parsers of API shapes when two features would otherwise both re-parse them.
- A rule that is pure today but used by one feature — still `lib/logic/`, so a
  second feature can reuse it without moving files.

## 2. What does NOT belong in `lib/logic/`

| Not logic | Where it goes |
|---|---|
| Widget rendering/state (incl. display-only masks with a fallback key a screen could change) | `presentation/view/widget/` (rounder-widgets) |
| Pages/screens/flows | `presentation/view/screens/` (rounder-screens) |
| Validators returning localized error messages | `<feature>/validation/` (rounder-validation) |
| `emit(...)`, state machines, folding API results | the cubit's own file |
| HTTP calls, persistence | `data/repo/…` (`petromin-arch`) |
| One-off expression used exactly once and trivial ('0$digits'-scale) | may stay inline — extraction is a judgment call |

## 3. Style inside the file

- **Top-level pure functions** (house style: compact, documented, testable) —
  no classes needed unless naming groups helps.
- No `BuildContext`, no `AppColors`/`AppLocaleKey` (no UI text), no `emit`, no
  `await` — input in, deterministic output out; document the contract with a
  `///` first line.
- Same-language naming: snake_case file, camelCase function named for what it
  returns (`normalizeSaudiLocalMobile`), not where it came from.
- No imports from `layout/` (features) — `lib/logic` is a leaf; features import
  it, never the other way round.

## 4. When to extract

Extract when (a) two or more call sites need it, (b) it is a real domain rule
(contact validation, phone shapes), or (c) it makes a cubit/screen method
readable. A trivial single-use expression can stay inline — never extract a
rule you cannot name.

## 5. Migrating existing logic

- When you touch a feature and find a pure helper inside it, move it to
  `lib/logic/<domain>_logic.dart` with `git mv`, update every import
  (package-absolute), and run `flutter analyze`.
- Do not leave a second `logic/` folder inside a feature: `lib/logic/` is the
  only logic home.

## Related skills

- `rounder-screens` — pages live in `presentation/view/screens/`; logic never
  renders UI.
- `rounder-widgets` — widgets never hide logic; they receive values/callbacks.
- `rounder-validation` — validators live in `<feature>/validation/`, not in
  `lib/logic/`.
- `petromin-arch` — cubits/repos/models call into `lib/logic/`, they do not
  replace it.
