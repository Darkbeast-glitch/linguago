# Linguago

Offline, on-device voice translator. MVP: spoken English ↔ French, optional
offline TTS playback, zero network dependency after model assets are present.
Full spec: `linguago_prd.docx` (source of truth — this file is a working
summary, not a replacement).

## Product boundaries (do not cross without asking)

- No accounts/auth, no Firebase/Supabase, no backend server, no cloud
  translation or cloud TTS APIs, no chat history, no generic chatbot UX.
- MVP language set is English + French only. A third language is
  architecturally supported (`SupportedLanguages`) but must stay
  `isEnabled: false` until the full speech → translation → TTS pipeline has
  been proven on real devices for en/fr.
- Never add an online fallback "just in case" — that violates the offline
  promise. If a local capability is missing (e.g. no TTS voice for a
  language), surface it as a capability gap in the UI, don't fetch from the
  network.

## Architecture — feature-first MVVM

```
View → ViewModel → Repository → Data Sources
```

- **View**: renders UI, forwards user actions to the ViewModel. No
  Firebase/network/AI/business logic in widgets, ever.
- **ViewModel**: a Riverpod `Notifier`, owns UI state, calls the repository,
  maps results/errors into state.
- **Repository**: an abstract contract (`TranslationRepository`) the
  ViewModel depends on. Swapping fake data for real Gemma/audio/TTS should
  only ever mean swapping the `Provider` override, never touching the
  ViewModel or View.
- **Data sources** (Milestone 2+): `GemmaDataSource`, `AudioDataSource`,
  `TtsDataSource` — the only places allowed to touch local inference,
  microphone APIs, or offline speech synthesis.

State management: **Riverpod only**, no codegen (`Notifier`/`NotifierProvider`
— not `riverpod_generator`), to keep the dependency surface small. Models:
**Freezed + json_serializable**, generated files (`*.freezed.dart`, `*.g.dart`)
live beside their source and are committed after `dart run build_runner
build --delete-conflicting-outputs`.

## Design system (`linguagodesigns/`)

Source: `designs_system.png` (LinguaLearn Design System v1.0), plus
`Get Started Screen.png`, `Homescreen.png`, `Tranlsate Screen.png` for layout
reference. Tokens live in `lib/app/app_theme.dart` (`AppColors`, `AppTheme`).

| Token | Hex |
|---|---|
| Primary Purple | `#7C3AED` |
| Accent Green | `#10B981` |
| Highlight Yellow | `#F59E0B` |
| Text Gray | `#6B7280` |
| Background Gray | `#E5E7EB` |

Type scale: H1 32/bold, H2 24/semibold, H3 18/medium, body 16/regular.
Currently uses the system font (no bundled custom font yet — `google_fonts`
was intentionally skipped for MVP since its default runtime font-fetching
would conflict with the offline requirement; revisit only with a
locally-bundled font asset).

The mockups show a full multi-language app (Spanish, German, etc.) — that's
the long-term product vision, not the MVP. Build UI generic enough to support
more languages later, but only wire up English/French for real.

Match the mockups' actual composition, not just their color palette — e.g.
the Translate screen mic is a compact button in a bottom toolbar (not a giant
centered circle), and source/target live inside one card split by a swap
button, not two separate floating cards. `Homescreen.png` was deliberately
**not** built (Expert Class/lesson cards are out of MVP scope) — only Get
Started → Translate exist as real screens.

Asset paths are case-sensitive on Android/iOS device builds even though
macOS's filesystem isn't — keep the casing in `pubspec.yaml`'s `assets:` list,
the actual folder/file names, and every `Image.asset(...)` call identical
(project convention: lowercase, e.g. `assets/images/flags.png`).

## Rules for how to work on this codebase (PRD §29)

1. Work incrementally, one milestone at a time — never generate the whole
   app in one pass.
2. Before writing code, list the exact files you're going to create/change.
3. Provide complete files, never partial snippets or "// rest of code".
4. Briefly explain each new/changed file and how it fits
   View → ViewModel → Repository → Data Source.
5. Never put Gemma/audio/TTS logic, or general business logic, in widgets.
6. Never call a data source directly from a View — always through the
   ViewModel → Repository.
7. Verify current package APIs before using them (`flutter_gemma`,
   `flutter_gemma_speech`, etc.) — do not invent methods; these are evolving
   packages.
8. Keep dependencies minimal — justify every new package.
9. Real local inference must be tested on real ARM64 devices, not just
   simulators/emulators.
10. After each milestone, run `flutter analyze` + `flutter test`, and note
    how to run/try what was just built before moving to the next milestone.

## Milestone status

- [x] **Milestone 1 — Flutter shell.** Theme, navigation (Get Started →
      Translator → Settings), translator UI wired to Riverpod with a
      `FakeTranslationRepositoryImpl` (canned data, no real audio/model),
      settings screen, Freezed models (`Language`, `TranslationResult`,
      `TranslationState`, `AppSettings`).
- [ ] Milestone 2 — Gemma boot (integrate `flutter_gemma`, run a model on a
      real device; verify current package API first).
- [ ] Milestone 3 — Audio capture wired to local inference; microphone
      permission handling (`MicrophonePermissionDeniedException` already
      modeled in `core/errors/app_exception.dart`).
- [ ] Milestone 4 — Reliable English → French short-phrase translation.
- [ ] Milestone 5 — French → English + language swap (swap UI already built).
- [ ] Milestone 6 — Offline TTS wired to `speak()`/`stopSpeaking()`.
- [ ] Milestone 7 — Third language (Ewe), only after 2–6 are proven.
- [ ] Milestone 8 — Hardening: errors, performance, permissions, privacy,
      device testing, release build.

## Try it

```
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # after touching any @freezed model
flutter analyze
flutter test
flutter run
```

Current flow (Milestone 1, fake data): launch → Get Started → tap the arrow
FAB → Translator screen → tap the mic → after ~1s of fake "recording" +
"processing", the PRD's sample sentence ("Where is the nearest pharmacy?" →
"Où est la pharmacie la plus proche ?") appears in the two bubbles. Tap the
speaker icon on the translation bubble — it toggles `isSpeaking` state but
doesn't play real audio yet (no TTS wired up). Settings is reachable via the
gear icon in the app bar.
