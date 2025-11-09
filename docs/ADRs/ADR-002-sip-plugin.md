# ADR-002: SIP Softphone via `flutter_sip_ua`

## Context

The Android-first mobile client must register SIP accounts, handle incoming call notifications, and provide media controls. The preferred plugin should expose SIP over WebSocket, DTMF, and background handling while remaining actively maintained.

## Decision

Use `flutter_sip_ua` instead of `flutter_pjsip`. The plugin bridges to the proven SIP UA stack from `sip.js`, supports WebSocket transport compatible with Telnyx, and integrates easily with Riverpod for state. It avoids compiling native C code, reducing build complexity on CI and for iOS. The dialer wraps `SIPUAHelper` for registration, outbound calls, and call-state listening.

## Consequences

* ✅ No native toolchain complexity; pure Dart + platform channels.
* ✅ Works with programmable voice providers via SIP over WebSocket.
* ⚠️ Limited codec control versus native PJSIP; must rely on SBC negotiation.
* ⚠️ Background incoming support on Android requires additional foreground service glue (documented in runbook).
