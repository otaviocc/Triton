# ADR-018: Per-Machine Signing via xcconfig

**Status:** Accepted

**Date:** 2026-06-27

**Context:**

The application is built on more than one machine, each signed under a different Apple developer
account — the maintainer's primary account and a personal Apple ID. Two settings differ between those
accounts:

- `DEVELOPMENT_TEAM` — the Apple Developer team identifier used for signing.
- The bundle-identifier prefix — an explicit App ID registered to one account cannot be reused by
  another, so the second account needs its own reverse-DNS prefix (e.g. `cc.otavio.OMG` instead of
  `com.otaviocc.OMG`).

Both values were hardcoded in the committed `OMG.xcodeproj/project.pbxproj` (`DEVELOPMENT_TEAM` and
`PRODUCT_BUNDLE_IDENTIFIER`). Switching machines meant editing a tracked file, which is noisy in git
and easy to commit by accident.

Unlike the sibling Stash project, the application has no Share Extension, no App Group, no Keychain
access group, and no runtime code that reads the bundle identifier. The OAuth redirect uses a fixed
custom scheme (`omglol://oauth/callback`) that is registered with omg.lol and is independent of the
bundle prefix. The change is therefore confined to build settings — there are no entitlements,
`Info.plist` identifiers, or Swift constants that must be kept in lockstep.

**Decision:**

Introduce `Config/Triton.xcconfig` as the single source for `DEVELOPMENT_TEAM` and a new
`TRITON_BUNDLE_PREFIX` build setting, and wire it as the project-level base configuration.

- The committed `Triton.xcconfig` holds the maintainer's defaults
  (`TRITON_BUNDLE_PREFIX = com.otaviocc`, `DEVELOPMENT_TEAM = S9X9XY5GF8`).
- `PRODUCT_BUNDLE_IDENTIFIER` in both target build configurations references
  `$(TRITON_BUNDLE_PREFIX).OMG`. `DEVELOPMENT_TEAM` is removed from the `pbxproj` entirely (including
  the empty target-level overrides) and now comes only from the xcconfig.
- `Triton.xcconfig` ends with `#include? "Triton.local.xcconfig"`. The `?` makes the include optional,
  so a second machine drops a gitignored `Config/Triton.local.xcconfig` overriding either setting and
  it wins, while the maintainer's primary machine builds with no local file.
- `Config/Triton.local.xcconfig.example` is committed as a template; `Config/Triton.local.xcconfig`
  is gitignored.

**Consequences:**

- _Positive:_ Switching developer accounts no longer touches tracked files. Team and prefix live in
  one place; the bundle identifier derives from the prefix so the two can't drift.
- _Positive:_ The committed defaults keep CI and the primary machine building with zero local setup.
- _Neutral:_ Building under a second account is a one-time `cp Config/Triton.local.xcconfig.example
  Config/Triton.local.xcconfig` followed by editing the two values.
- _Negative:_ The base-configuration wiring lives in `pbxproj`, so a future "reset project settings"
  in Xcode could drop the `baseConfigurationReference`; verify resolved values with
  `xcodebuild -scheme OMG -showBuildSettings` if signing behaves unexpectedly.

**Related Decisions:**

- [ADR-017: Direct Distribution Outside App Store](ADR-017-direct-distribution-outside-app-store.md) —
  signing and notarization context this configuration feeds into.

**Notes:**

Verify a machine's resolved values with:

```bash
xcodebuild -scheme OMG -showBuildSettings \
  | grep -E 'TRITON_BUNDLE_PREFIX|DEVELOPMENT_TEAM|PRODUCT_BUNDLE_IDENTIFIER'
```
