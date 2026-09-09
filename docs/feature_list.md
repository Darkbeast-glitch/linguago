# Linguago Feature & Improvement Roadmap

This document captures feedback, feature requests, and usability enhancements for Linguago.

---

## 1. Uncertainty & Low-Confidence Handling (Travel UX)

> **Inspiration / User Feedback:**
> *"Offline is exactly the right constraint for travel. How does the app communicate uncertainty when speech recognition or translation is shaky? A confidently wrong sentence can be worse than asking the user to try again."* — @grunersoftware

### Problem
In real-world travel situations (noisy markets, train stations, different accents), speech recognition or LLM inference might produce low-confidence or ambiguous outputs. In a foreign country, a confidently incorrect translation can cause serious misunderstandings.

### Proposed Solutions & Features

- [x] **Dual Verification Display (Current Baseline):**
  - Always show the transcribed input text (what the model heard) directly above the translated output.
  - Allows the user to sanity-check what was captured before relying on or playing the translation.

- [ ] **Low-Confidence Audio / Ambiguity Warning:**
  - Detect low-confidence speech input or noisy audio.
  - Show an intuitive visual indicator (e.g., amber warning border or badge: *"Audio unclear — tap to retry"*) rather than guessing blindly.

- [ ] **Inline Transcript Quick-Edit:**
  - If the model mishears 1–2 words, allow tapping the source text to quickly correct it with the keyboard without having to re-record the entire phrase.

- [ ] **"Did you mean?" / Alternative Interpretations:**
  - For ambiguous colloquialisms or homophones in noisy environments, display top candidate phrases when uncertainty is high.

---

## 2. Core Translation & Voice Features

- [x] **100% Offline On-Device Inference:** Powered by Gemma 4 E2B via LiteRT (`.litertlm`).
- [x] **Audio Pulse Animation:** Visual ripples around the mic to give responsive feedback while listening.
- [x] **Popular Translation Presets:** Quick 1-tap switching between top language pairs.
- [ ] **Two-Way Split-Screen Conversation Mode:**
  - Reverse view for face-to-face conversations across a table.
- [ ] **Offline Text-to-Speech (TTS):**
  - Native offline voice playback for target translations.
- [ ] **Saved / Starred Translations:**
  - Save essential phrases (allergies, hotel address, emergency info) for offline reference without re-translating.

---

## 3. Language Expansion

- [x] English ↔ French (Verified end-to-end on hardware)
- [ ] Spanish, German, Japanese, Chinese, Arabic, Portuguese
- [ ] Regional African Languages (e.g., Ewe, Twi, Yoruba, Swahili)
