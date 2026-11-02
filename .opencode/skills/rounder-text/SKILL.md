---
name: rounder-text
description: Text-style rule for the Rounder Flutter app (package rounder_application) — ALL text comes from the Figma type scale mirrored in ONE place, `lib/core/theme/app_text_styles.dart` (`AppTextStyles`), consumed as `AppTextStyles.x` or `AppTextStyles.x.copyWith(...)` — never a hand-written `TextStyle(fontFamily:…, fontSize:…, fontWeight:…)` inline, never a second per-feature scale file. ALWAYS use when creating, editing or reviewing ANY text in this repo (titles, labels, buttons, captions, headings, hints, dialogs), whenever you are about to write `TextStyle(` or see one in existing code, when adding a new size/weight to the app or to the Figma design system, or when the user says "ستايل النص", "تيكست ستايل", "الخط", "font", "نص صغير", "عنوان", "خط عريض", "greeting style" — even for a single label. Pairs with rounder-widgets (file split) and rounder-screens; the design source of truth is the Figma file's text styles ("03 — Brand System" page).
---

# Rounder Text — One Type Scale, Mirrored from Figma

The hard rule: **a text style has exactly one home.** Figma owns the scale; the
app mirrors it once; widgets reference it by name. Nothing writes
`TextStyle(fontFamily: ..., fontSize: ..., fontWeight: ...)` by hand anywhere.

```
Figma "Rounder — Design System" text styles ("03 — Brand System" page)
        ↔  mirrored 1:1  ↔
lib/core/theme/app_text_styles.dart   ← the single mirror (AppTextStyles)
        ↑ referenced by                      (static const TextStyle …, height as fraction)
AppTheme.light.textTheme (M3 roles)   ← so ListTile/Button/Chip ambients resolve
        ↑ referenced by
lib/layout/…/widget|screens   — style: AppTextStyles.x(.copyWith(...))
```

Live examples: `lib/layout/global/features/auth/presentation/view/widget/login_phone_entry.dart`,
`lib/layout/resident/features/association/presentation/view/widget/union_line.dart`,
`lib/layout/resident/features/bookings/presentation/view/widget/order_card.dart`
— all moved off ad-hoc `TextStyle(...)` onto the scale in the 2026-11 sweep.

## 1. The class shape

```dart
abstract final class AppTextStyles {          // house style of AppColors: no instances
  static const TextStyle headingH1 = TextStyle(fontFamily: cairo, fontSize: 24, fontWeight: FontWeight.w700, height: 36 / 24);
  …
}
```

- Height is the Figma line-height written as the fraction that produced it
  (`36 / 24`), never a rounded decimal — it keeps the numbers auditable
  against the design.
- Entries are grouped and named after the Figma groups: `display*`, `heading*`,
  `body*`, `caption*`, `tiny*`, plus the plain weight buckets the design file
  lists at top level (`extraBoldN`, `mediumN`, `monoMedium25`).
- Constant name = (weight word)(size): `captionBold13`, `bodyRegular17`,
  `headingH4`, `extraBold20`. If the Figma style has a role name (`H1`,
  `Label/Action`), the role name wins: `headingH1`, `labelAction`.

## 2. How to pick a style

1. If the design names the text style → use the role constant (`Display/Hero` →
   `displayHero`, `Heading/H2` → `headingH2`, `Body/Small` → `bodySmall`,
   `Caption/Regular 13` → `captionRegular13`).
2. If you only know size + weight → the same tuple defines the name:
   15/w700 → `bodyBold15`, 12/w600 → `bodySemiBold12`, 20/w800 → `extraBold20`.
3. Wire nothing extra: `AppTheme.light.textTheme` already maps the Material 3
   roles (titleMedium → `bodyBold15`, labelLarge → `labelAction`,
   bodyMedium → `bodyMedium`, …) so ambient text inside `ListTile`,
   `TextButton`, `Chip`, plain `Text` renders on the scale automatically.

## 3. The `copyWith` policy

Allowed, only where the screen genuinely deviates from the scale:

```dart
style: AppTextStyles.bodySmall.copyWith(color: AppColors.teal, height: 26 / 14),
```

- Color is the normal exception (the scale is intentionally color-less).
- `height` only when the pulled frame proved a different line-height — and NOT
  when the value equals the constant's own height (no `copyWith(height: 24/15)`
  on `bodyRegular15`).
- `fontWeight` only on an AMBIENT base (§4), where the raw markup carried an
  explicit weight.
- Never `copyWith(fontFamily/fontSize/…)` to invent a 14th size — that's the
  anti-pattern this rule exists to kill.

## 4. Legacy conversion rules (sweeping old code)

When a legacy `Text(..., style: TextStyle(...))` has no explicit fontSize it
was merging with its AMBIENT style — convert it by naming the ambient:

| Context of the Text                               | Base constant              |
|---------------------------------------------------|----------------------------|
| `ListTile(title:` (theme titleMedium)             | `AppTextStyles.bodyBold15` |
| `ListTile(subtitle:` / plain body content         | `AppTextStyles.bodyMedium` |
| `TextButton/ElevatedButton/Chip(label/child:`     | `AppTextStyles.labelAction`|

If the legacy style has a size+weight, the constant with that tuple replaces
the whole `TextStyle(...)` and only color/height/image extras move into
`copyWith`. Targets that don't exist in the scale: snap the size to the
nearest scale entry (29 → `displayLarge`, 30 stays `displayBold30`); document
the snap in the diff.

Completion check for any touched feature: `grep -rn "TextStyle(" lib/` must
return hits **only** inside `core/theme/app_text_styles.dart`.

## 5. Governance — when the scale needs to grow

- A new size/weight is never introduced inline in a widget. If a tuple is
  needed repeatedly, add a constant to `app_text_styles.dart` in the matching
  group (no baked height unless the design gives one) AND add the matching
  text style to the Figma file so both stay canon. The extension block added
  during the 2026-11 sweep (`extraBold15/17/18/19/20/22/23/24/26`,
  `captionSemiBold13`, `medium25`) is pending design review — the Figma Brand
  System page is locked, so flag it to the designer before it grows.
- `FontWeight.w900` does not exist in this app: `pubspec.yaml` registers Cairo
  400–800 only, so a `w900` renders as `w800`. Never write a `black*` constant
  or a `w900` — use the `extraBoldN` family.
- Numerals may use `monoMedium25` (Roboto Mono) where the design asks for the
  countdown/mono treatment.
- A per-feature alias class (like the dashboard's `HomeTextStyles`) is allowed
  ONLY as a thin named layer where every entry derives from `AppTextStyles`
  (`static TextStyle weather = AppTextStyles.bodySemiBold11.copyWith(...)`) —
  it must never restate family/size/weight numbers, and must not be
  `const`-assigned since `copyWith` is runtime.

## Related skills

- `rounder-widgets` — widgets compose the styles; they never own a private
  `TextStyle`.
- `rounder-screens` — screens keep skeletons; typography lives on the scale.
- `rounder-shared-widgets` — a promoted shared widget imports the same scale,
  not a copy of the styles it used in its old screen.
- The Figma file itself: text styles on the locked "03 — Brand System" page
  are the source of truth; keep the app mirror name-compatible with it.
