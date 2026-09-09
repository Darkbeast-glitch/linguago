# App Store listing copy

Draft copy for App Store Connect. Kept in the repo so the wording is versioned
alongside the app rather than living only in a web form.

Character limits are Apple's and are enforced silently — text over the limit is
truncated without warning.

---

## App Name (30 max)

```
Linguago: Offline Translate
```

27 characters. "Linguago" alone was already taken.

## Subtitle (30 max)

```
Translate speech, no internet
```

29 characters.

## Promotional Text (170 max)

Editable any time without submitting a new build — use it for announcements.

```
Your voice never leaves your phone. Linguago translates speech using AI that runs entirely on your device — no account, no servers, and no internet once it's set up.
```

165 characters.

## Keywords (100 max)

Comma-separated, **no spaces after commas** — spaces count against the limit.
Words already in the app name and subtitle are indexed automatically, so they
are deliberately not repeated here.

```
offline,voice,speech,interpreter,travel,private,abroad,phrase,language,on-device,no wifi,talk
```

93 characters. No competitor names or trademarks, which Apple rejects.

## Description (4000 max)

```
Linguago translates spoken language on your phone — with the internet switched off.

Speak a phrase, see it translated, and hear it read back. The AI model runs entirely on your device, so nothing you say is ever uploaded, stored on a server, or seen by anyone else.

Built for the moments connectivity fails you: a foreign airport with no roaming, a rural clinic, a market stall three streets past the last usable signal.


HOW IT WORKS

Tap the microphone and speak. Linguago transcribes what you said and translates it in one step, then reads the result aloud in the other language. Tap the text box to type instead — useful in noisy places, or to correct a word it misheard.

Swap the direction with a single tap to hold a back-and-forth conversation.


GENUINELY PRIVATE

• No account, no sign-in, no email address
• Your recordings are deleted the moment they have been read
• No analytics, no crash reporting, no advertising
• After first-time setup, the app makes no network requests at all

This is not a claim about a privacy policy. There is no server for your voice to reach.


BEFORE YOU DOWNLOAD

Linguago needs a one-time 2.6 GB download to install its translation model. This takes roughly 5 to 15 minutes on Wi-Fi. Everything works offline afterwards.

The model also needs a device with at least 6 GB of memory. On older devices, Linguago tells you plainly rather than crashing.


LANGUAGES

English, French, Spanish, German, Italian, Portuguese, Dutch, Russian, Arabic, Hindi, Chinese, Japanese, Korean, Turkish and Polish.


BETA

Linguago is early software. Speech recognition can mishear you, and translation quality varies between languages — English, French and Chinese have had the most testing.

If a translation looks wrong, type the phrase instead. The text box is more reliable than the microphone, and the app says so where it matters.

We would rather tell you this up front than have you discover it.


OPEN SOURCE

Linguago is open source under the Apache 2.0 licence. You can read every line, including exactly how audio is handled:

github.com/Darkbeast-glitch/linguago
```

## App Review Notes

Not shown to users. This is what stops a reviewer rejecting the app as broken
when it asks for 2.6 GB before doing anything.

```
This app translates speech offline using an on-device AI model (Google Gemma 4).

FIRST LAUNCH: The app downloads a 2.6 GB model once. This takes roughly 5-15 minutes on Wi-Fi. A progress bar is shown throughout, and the download can be cancelled and resumed from the setup screen. The app cannot translate until this completes — please allow it to finish before testing.

DEVICE REQUIREMENT: The model needs 6 GB or more of device memory. On devices with less, the app shows an "unsupported device" message by design rather than crashing. Please test on iPhone 15 Pro or newer.

TO TEST: After setup completes, tap the microphone on the Translate screen, speak a short English phrase, then tap stop. The transcription and its French translation appear within a few seconds. Tap the speaker icon to hear it read aloud. Alternatively, tap the text box and type a phrase to translate without using the microphone.

PRIVACY: No data is collected or transmitted. Audio is written to a temporary file, read once by the on-device model, and deleted immediately. The only network request the app ever makes is the one-time model download from huggingface.co, where Google publishes the model.

MICROPHONE: Used solely to capture the phrase being translated, only while the user is actively recording.

Source code: github.com/Darkbeast-glitch/linguago
```

## App Privacy answers

- Data collected: **none**
- Data shared with third parties: **none**
- Data used for tracking: **none**
- Privacy policy URL: `https://darkbeast-glitch.github.io/linguago/privacy.html`
- Support URL: `https://darkbeast-glitch.github.io/linguago/support.html`
- Marketing URL (optional): `https://darkbeast-glitch.github.io/linguago/`

## Other fields

| Field | Value |
|---|---|
| Category (primary) | Utilities |
| Category (secondary) | Travel |
| Age rating | 4+ |
| Copyright | 2026 Julius Boakye |
