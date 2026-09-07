# Privacy Policy — Linguago

**Last updated:** 7 September 2026

Linguago translates speech using a model that runs on your device. This policy
describes exactly what the app does with your data. The short version: your
voice and your translations stay on your phone.

---

## What we collect

**Nothing.** There is no account to create, no server to send data to, and no
analytics, crash reporting, or advertising SDK in the app.

We cannot see your recordings, your translations, or how you use the app,
because none of it is transmitted anywhere.

---

## Your voice

When you tap the microphone:

1. Audio is recorded to a **temporary file** in the app's private storage.
2. That file is read once and passed to the translation model **on your
   device**.
3. The file is **deleted immediately** after it has been read.

The recording is never uploaded, never backed up by the app, and never reused
for a second translation. If the app is closed mid-recording, the partial file
is discarded.

Translation happens entirely on your phone using Google's Gemma model. The
audio does not reach Google, us, or anyone else.

---

## The one time Linguago uses the network

The translation model is about 2.6 GB and cannot be bundled inside the app, so
it is **downloaded once** the first time you set the app up.

That download connects to **huggingface.co** (Hugging Face), where Google
publishes the model. As with any download, Hugging Face and its CDN can see
your IP address and that you requested the file. We receive nothing from this —
the request goes directly from your phone to them.

You can avoid this entirely by copying the model onto your device yourself; see
the project README. After the model is present, **the app makes no network
requests at all** and works with the radio switched off.

---

## Speech playback — please read this one

When you tap the speaker to hear a translation, Linguago hands the translated
**text** to your device's own speech engine.

- **On iPhone and iPad**, speech is synthesised on-device by Apple's system
  voices. Nothing is transmitted.
- **On Android**, playback uses whichever text-to-speech engine your device is
  set to use. Most engines speak offline once a voice is installed, **but some
  send text to their own servers**. That behaviour belongs to the engine you
  have selected, not to Linguago, and we cannot control or observe it.

If this matters to you, check **Settings → General management →
Text-to-speech** on Android, install offline voice data for your language, or
turn off *Auto-play translated speech* in Linguago's settings so nothing is
spoken unless you ask.

We flag this because it is the only path by which translated text could leave
your device, and it would be dishonest to describe the app as fully offline
without saying so.

---

## What is stored on your device

Small settings, saved locally and never transmitted:

- Whether you have seen the welcome screen
- Your chosen source and target languages
- Which languages you have used recently
- Whether translated speech plays automatically
- The downloaded translation model

**No transcriptions or translations are saved.** Text disappears when you close
the screen or start a new translation. There is no history feature.

Deleting the app removes all of it, including the model.

---

## Permissions

| Permission | Why |
|---|---|
| **Microphone** | To hear the phrase you want translated. Used only while you are recording. |
| **Internet** | Only for the one-time model download described above. |

---

## Children

Linguago has no accounts, no social features, no advertising, and collects no
data, so there is nothing to gather from a child or anyone else.

---

## Changes

This policy is versioned alongside the source code. Its history is public, so
any change can be inspected in the repository.

---

## Contact

Questions or concerns: open an issue at
<https://github.com/Darkbeast-glitch/linguago/issues>.

---

## For store listings

Values for the Google Play **Data safety** form and Apple's **App Privacy**
questionnaire:

- Data collected: **none**
- Data shared with third parties: **none**
- Data used for tracking: **none**
- Data encrypted in transit: not applicable — no data is transmitted
- Account deletion: not applicable — no accounts

The model download is a first-party file download, not data collection.
Android's TTS behaviour described above is the user's chosen engine, not a
Linguago integration, and is disclosed here for transparency rather than
because it constitutes collection by this app.
