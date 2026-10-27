---
name: rounder-validation
description: Validation-file rule for the Rounder Flutter app (package rounder_application) — form validators (`String? Function(String?)`) live in the feature's validation folder as one `abstract final class <Feature>Validators` in `<feature>/validation/<feature>_validators.dart`, static, pure, and resolving their messages from AppLocaleKey — never re-inlined as duplicated closures inside two different screens. ALWAYS use when creating, editing or reviewing ANY form field, validator, regex rule or cross-field check (password confirm, name minimums, email format) in this repo; whenever a validator is needed for a TextFormField/TextFormField-style widget; whenever the user says "فليداتور", "التأكد من الحقل", "validation", "rules", "نفس الرول مكرر في ملفين"; and when consolidating validation that already exists in two places. Regexes live ONLY here — no screen ever holds its own copy of an email/password/phone pattern.
---

# Rounder Validation — Validators Live in the Feature's `validation/` Folder

The hard rule: **a validation rule has exactly one home.** When the same rule
(a regex, a minimum length, a pair-match) is needed by two screens, it is
written once and shared — never re-inlined per screen. The home:

```
lib/layout/<role>/features/<feature>/
├── validation/
│   └── <feature>_validators.dart   # abstract final class <Feature>Validators
├── logic/ → pure derivations (rounder-logic) — NOT validators
└── presentation/… → screens/widgets CALL these; they never own them
```

Live example in this repo: `lib/layout/global/features/auth/validation/auth_validators.dart`
— `requiredField`, `name`, `email`, `password`, `optionalIntlPhone` and the
`confirm` factory — used by both `email_login_screen.dart` and the register
form card, whose private `_emailValidator`-style copies it replaces.

## 1. The class shape

```dart
abstract final class AuthValidators {
  static String? email(String? value) { … }                                  // one rule = one message
  static String? Function(String?) confirm(TextEditingController source) =>  // cross-field rule
      (value) => value == source.text ? null : AppLocaleKey.passwordMismatch.tr();
}
```

- `abstract final class` + static members — the house style of `AppColors`
  and `AppLocaleKey`; no instances, ever.
- One static method per rule. Cross-field checks become **factory methods
  returning the validator closure**, because they need the other field's live
  text at validation time, not at construction time.

## 2. Contract of every validator

- Signature: `String? Function(String?)` — `null` = valid; otherwise the
  message the `TextFormField` shows.
- **Messages come from `AppLocaleKey` only** (`AppLocaleKey.x.tr()`) — no
  hardcoded Arabic/English and no `context.apiTr` (petromin-i18n); the
  validator is locale-agnostic, `.tr()` resolves at render time.
- Pure and side-effect-free: read the value (and the referenced fields only),
  never write to controllers or state inside a validator.
- Empty/missing rules and format rules are separate messages (`requiredField`
  vs `emailInvalid`) — a validator may return both, in that order.

## 3. Screens and widgets compose them

- `validator: AuthValidators.email` — direct tear-off when the rule is final.
- Optional fields keep optionality at the call: e.g. `optionalIntlPhone`
  returns `null` for empty input by contract, so the widget needs no wrapper.
- The shared entry widgets may default to the shared required check
  (`validator ?? AuthValidators.requiredField`) — the widgets folder and the
  validators folder cooperate; neither duplicates the other's rules.

## 4. When NOT to put it here

- Transformation (`'0512345678'` formation, masking) → `logic/` (rounder-logic).
- Server-side checks (a 422 response, an API-integrity rule) → repo/cubit
  error mapping — validators are for form feedback before submit only.
- One-shot throwaway checks in a wizard step may stay inline — but the moment
  a second screen needs the same rule, it moves here.

## Related skills

- `rounder-logic` — pure helpers vs validators: validators return
  localized *messages*, logic returns *values*.
- `rounder-widgets` — widgets never carry regex rules; they pass
  `AuthValidators.x` into the field.
- `petromin-i18n` — every validator message is a key in all three JSON files.
