# 🎧 Reason2Funk App

Official Flutter app for **Reason2Funk Records** — underground house music label focused on jackin’ grooves, soulful rhythms, and creative freedom.

## Goals

- Showcase artists and releases
- Stream live DJ sets and events
- Offer exclusive content and merch
- Provide powerful **Studio Tools** for DJs and producers (OSC control, MIDI mapping, visuals, OBS integration, etc.)

This repo contains the main/public version of the app development.

## Versions & History

During development multiple iterations were created (v1 → v2 → v3). The more advanced studio tools work (especially OSC handlers for Android/iOS and the full studio tab) ended up concentrated in the `reason2funk_app_Claude-Only` repository in this workspace.

Other related snapshots exist (see `R2F_AndroidApp` folder).

## Current Status (as of 2026 cleanup)

This project was part of a large personal workspace audit. Multiple historical versions and related tools were preserved and pushed to GitHub because the work had real soul and engineering effort, even if it wasn't actively shipping yet.

**Note**: Development happened before I fully standardized on pixi for Python-side work. This is a Flutter project, so the relevant tooling is standard Flutter + Dart.

## Running

```bash
# Example using one of the version folders
cd reason2funk_app_v2   # or whichever has the state you want

flutter pub get
flutter run
```

Assets are heavily optimized (WebP) and there is custom theming.

## Studio Tools Vision

The most interesting part of the later versions was the **Studio Tools** tab, intended to turn a phone/tablet into a control surface for live electronic music performance:

- Real-time OSC to control CDJs, mixers, drum machines, etc.
- MIDI mapping
- Triggering visuals / Magic Music Visuals
- OBS scene/macro control
- Audio routing awareness
- Live stream helpers

Gear presets for common Jacksonstrut / Reason2Funk setups were planned.

## Related Projects

- `reason2funk_app_Claude-Only` — more advanced v3 studio tools work
- `reason2post-engine` — Node backend for releases, scheduling, and social automation
- `R2F_AndroidApp` — another asset-heavy snapshot
- `Reason2PostGPT` — GPT-assisted content experiments

## License & Collaboration

Currently private / limited release while the label and tools mature.

Interested in collaborating on underground house tools, performance interfaces, or label tech? Reach out:

**reason2funkrecords@gmail.com**

---

**Reason2Funk Records** — jackin’ grooves • soulful rhythms • creative freedom.