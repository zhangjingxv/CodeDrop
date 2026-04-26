# CodeDrop

A minimal Mac menu bar app that automatically captures verification codes from your clipboard.

When your iPhone receives an SMS or email OTP, Apple's Universal Clipboard silently syncs it to your Mac. CodeDrop sits in the menu bar, detects the code the moment it arrives, and keeps it one click away.

---

## How it works

```
iPhone receives SMS/email  →  copy the code on iPhone
        ↓
Universal Clipboard syncs to Mac (same Apple ID)
        ↓
CodeDrop detects it automatically
        ↓
System notification + saved in menu bar history
        ↓
Click to copy — done
```

No companion app. No manual input. No browser extension.

---

## Features

- **Auto-detect** — recognizes 4–8 digit OTP codes, with or without keywords like "验证码" / "code" / "OTP"
- **Instant history** — keeps the last 20 codes, shows 8 in the menu
- **One click copy** — click any entry to write it to clipboard
- **System notification** — pops up the moment a code is captured
- **Menu bar only** — no Dock icon, stays out of the way

---

## Requirements

- macOS 13 Ventura or later
- iPhone and Mac signed in to the same Apple ID
- **Handoff** enabled on both devices (System Settings → General → AirDrop & Handoff)

---

## Install

**Build from source:**

```bash
git clone https://github.com/zhangjingxv/CodeDrop.git
cd CodeDrop
open OTPClip.xcodeproj
```

Press `⌘R` in Xcode to build and run.

---

## Project structure

```
OTPClip/
├── OTPClipApp.swift       App entry point
├── AppDelegate.swift      Menu bar setup & menu rendering
├── ClipboardMonitor.swift Clipboard polling & notification
└── OTPDetector.swift      Regex-based OTP detection
```

---

## License

MIT
