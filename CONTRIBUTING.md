# Contributing to Linguago

Thanks for your interest. This document covers how to get set up, the rules the
codebase holds itself to, and several sharp edges in the toolchain that will
otherwise cost you an afternoon.

---

## Setup

`DEVELOPMENT_TEAM` is blank in the checked-in Xcode project — set your own
before building for iOS (see the [README](README.md#requirements)). Never
commit a team ID or anything from `key.properties`; that file is gitignored,
and `key.properties.example` must only ever hold placeholders.

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze     # must be clean
flutter test        # must pass
```

You need a **real arm64 device** to do anything meaningful. x86_64 emulators
cannot run the model at all, and the iOS Simulator can't capture audio. See the
[README](README.md#getting-the-model-onto-the-device) for getting the 2.6 GB
model onto a device without re-downloading it every time.

---

## Toolchain traps

These have each broken the build at least once. They are not obvious from the
error messages.

### Windows-only packages break code generation

Codegen dies with:

```
Exception: Missing implementation of visitDotShorthandInvocation
SDK language version 3.12.0 is newer than `analyzer` language version 3.9.0
```

**Cause:** `win32` and `win32_registry` use Dart 3.12's *dot shorthand* syntax
(`Data1 = .parse(...)`, `RegistryAccess(.new(0x2001F))`). The analyzer bundled
with Freezed can't parse it and throws instead of skipping. Both are pulled in
transitively by `path_provider` / `connectivity_plus` as their Windows
implementations — this app never builds for Windows, but the analyzer reads them
anyway.

**Fix (already in `pubspec.yaml`):**

```yaml
dependency_overrides:
  win32: ^5.5.4
  win32_registry: ^1.1.5
```

Don't remove these without checking codegen still runs. Upgrading Freezed past
this is blocked in both directions: Freezed 4 needs Dart ≥3.13, and the Flutter
SDK pins `meta 1.18.0`, which caps the analyzer below what newer `build_runner`
wants.

### Generated files are committed

`*.freezed.dart` and `*.g.dart` live beside their sources and are checked in.
After touching any `@freezed` model:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Freezed 3 requires `abstract class X with _$X` — a plain `class` fails with
"missing concrete implementations".

### "Installed" and "active" are different things in flutter_gemma

`isModelInstalled()` reports file presence. `getActiveModel()` needs an *active
model identity*, and throws a bare `StateError` without one. The identity is
persisted but only restored by
`FlutterGemmaPlugin.instance.modelManager.ensureInitialized()`, which neither of
those methods calls for you. `GemmaDataSource` handles this; if you add a new
entry point, await it first.

### Interrupted downloads leave a corpse

A `flutter_gemma` bug: an interrupted download leaves its task record in
`background_downloader`'s database. The next attempt attaches to the dead
record, fails instantly, and **doesn't delete it** — so retry is permanently
broken until the app is reinstalled.
`GemmaDataSource._purgeStaleDownloadTasks()` works around it. Don't remove that
without confirming the upstream fix.

### Widget tests need a phone-shaped viewport

Flutter's default test viewport is 800×600 — short and wide, unlike any phone.
The Get Started screen overflows at that height and layout aborts, which looks
like a mysterious "found 0 widgets". Use the `_usePhoneViewport` helper in
`test/widget_test.dart`.

Also: the Get Started screen runs a **continuous** pulse animation, so
`pumpAndSettle` never returns. Pump a bounded number of frames instead.

---

## Architecture rules

The dependency direction is strict:

```
View → ViewModel → Repository → Data Source
```

1. **No business logic in widgets.** No inference, no microphone, no speech
   synthesis, no file I/O. Views render state and forward user intent.
2. **Views never call a data source.** Always through ViewModel → Repository.
3. **Data sources are the only place platform APIs live.** `GemmaDataSource` is
   the only file that imports `flutter_gemma`; `AudioDataSource` the only one
   that touches the mic; `TtsDataSource` the only one that speaks.
4. **Riverpod only**, and without codegen — plain `Notifier` /
   `NotifierProvider`, not `riverpod_generator`.
5. **Freezed for models.** Immutable, with `copyWith`.

The point of (2) and (3) is that swapping the model, the runtime, or the TTS
engine should mean changing one provider override — and nothing above the
repository should notice.

---

## Product boundaries

These are deliberate. Please open an issue before crossing them:

- **No backend, no accounts, no cloud APIs.** Not for translation, not for
  speech, not for analytics. The offline guarantee is the product.
- **No online fallback "just in case."** If a local capability is missing — no
  voice for a language, say — surface it as a capability gap in the UI. Reaching
  for the network when local fails silently breaks the promise the app makes.
- **No feature creep into a chat app.** No conversation history, no generic
  assistant, no lessons.

Firebase appears in CI configuration for build distribution only (its unused
Android config file was removed from the repo). It is not a
dependency of the app and must not become one.

---

## Testing

Run `flutter analyze` and `flutter test` before opening a PR. Both must be clean.

**What deserves a test:**

- Parsing logic — `TranslationOutputParser` has the densest coverage for a
  reason: the model's output format varies between runs, and every real reply
  shape we've observed is pinned as a regression test.
- ViewModel state transitions, especially error paths.
- Anything you fixed. A bug without a test invites its own return.

**What can't be tested in CI:** anything requiring the model. Inference,
recording, and speech need a real device with a 2.6 GB model on it. Say
explicitly in your PR what you verified on-device and what you didn't.

Don't claim something works because it compiles. Several bugs in this codebase's
history passed `flutter analyze` cleanly and failed instantly on hardware.

---

## Verify package APIs before using them

`flutter_gemma` shipped 13 releases in two weeks at one point. `flutter_tts`
implements different methods on different platforms — `isLanguageInstalled`
simply **does not exist on iOS**, which silently disabled speech there until it
was caught.

Before calling into these packages, read the installed source:

```bash
ls ~/.pub-cache/hosted/pub.dev/flutter_gemma-*/lib/
```

Don't rely on blog posts, older docs, or memory. If a method's platform support
is unclear, guard each call separately so an unimplemented one degrades to "no
answer" rather than "no".

---

## Comments

Explain **why**, not what. The code already says what it does.

Good — it stops someone "fixing" a deliberate choice:

```dart
// GPU on Android is both faster *and* lighter than CPU — 3808 vs 557 tok/s
// prefill and 676 MB vs 1733 MB. The trade-off inverts on iPhone.
preferredBackend: PreferredBackend.gpu,
```

Not useful:

```dart
// Set the preferred backend to GPU
preferredBackend: PreferredBackend.gpu,
```

Where a measurement drove a decision, record the number. Where a workaround
exists for an upstream bug, say which bug and what would let us remove it.

---

## Pull requests

- One concern per PR.
- Describe **what you tested on a real device**, and on which device.
- Include the raw model output if you changed anything about prompting or
  parsing — that's the only evidence that matters there.
- Update [CLAUDE.md](CLAUDE.md) if you change something a future contributor
  would otherwise rediscover the hard way.

---

## Good first issues

- **Test fr→en.** The reverse direction has never been verified end to end.
- **Test the other 13 languages.** Only English→French has run on hardware.
- **Mirror the model to resumable hosting**, so users stop losing 2.6 GB
  downloads at 90%.
- **Add a language.** See the
  [README](README.md#adding-a-language) — mostly a data change, but the quality
  claims need real testing.
- **Wire up or remove the dead taps** on the home screen (grid, search).
- **An integration test** covering launch → record → translate → speak.
