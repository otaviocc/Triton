# ADR-017: Direct Distribution Outside App Store

**Status:** Accepted

**Date:** 2025-01-22

**Context:**

When deciding how to distribute the macOS application, I evaluated two primary distribution channels:

1. **Mac App Store:** Apple's official marketplace with built-in distribution and discovery
2. **Direct distribution:** Downloadable DMG/PKG outside the App Store (sideloading)

Key considerations influencing this decision:

- **Development velocity:** Ability to iterate and release updates quickly
- **Review process overhead:** Time and friction introduced by App Store review cycles
- **Cost implications:** Additional expenses beyond existing Apple Developer Program membership
- **Security and trust:** Maintaining user confidence through proper code signing and notarization
- **Control over distribution:** Flexibility in release timing and update deployment

The application requires an omg.lol account for authentication and core functionality. Apple's App Store review process requires providing reviewers with a functional test account, which would necessitate purchasing an additional omg.lol address specifically for review purposes.

**Decision:**

I chose to distribute the application directly outside the Mac App Store through downloadable DMG or PKG installers. Users download and install the application manually (sideloading), bypassing the App Store entirely.

**Distribution Approach:**

1. **Direct downloads:** Hosted files available from GitHub releases
2. **Code signing:** Application binary signed with Apple Developer ID certificate
3. **Notarization:** Binary submitted to Apple's notarization service for malware scanning
4. **Gatekeeper compliance:** Notarized app passes macOS Gatekeeper checks on first launch
5. **Manual updates:** Users download and install updates manually

**Security Measures (Still Applied):**

Despite not being distributed through the App Store, the application maintains the same security practices:

- **Code signing required:** Binary must be signed with valid Developer ID
- **Notarization required:** Apple's automated security scan must pass before distribution
- **Gatekeeper verification:** macOS verifies signature and notarization on first launch
- **Static analysis:** Binary undergoes Apple's automated malware and security checks
- **Developer accountability:** Apple Developer ID ties the application to verified developer account

The only difference from App Store distribution is the absence of manual human review. All automated security checks, signing requirements, and notarization processes remain identical.

**Consequences:**

### Positive

- **Faster iteration cycles:** No waiting for App Store review approval (typically 24-48 hours per submission)
- **Immediate releases:** Updates can be deployed as soon as they're ready
- **No review friction:** Avoid potential rejections requiring code changes and resubmission
- **Cost savings:** No additional omg.lol subscription required for App Store review account ($20/year saved)
- **Developer Program only:** Single $99/year Apple Developer membership covers all requirements
- **Release control:** Full control over timing, rollback, and phased rollouts
- **No guideline restrictions:** Freedom from App Store Review Guidelines constraints (beyond security requirements)
- **Testing flexibility:** No need to maintain separate review-specific test accounts

### Negative

- **No App Store discovery:** Users cannot find the app through Mac App Store search
- **Manual update flow:** Users must manually check for and install updates (unless in-app updater implemented)
- **Trust barrier:** Some users hesitate to install applications outside the App Store
- **Distribution responsibility:** Must host files on reliable infrastructure (GitHub releases)
- **No App Store features:** Cannot leverage TestFlight, automatic updates, or App Store metadata/screenshots for marketing

### Neutral

- **Notarization turnaround:** Apple notarization still required but typically completes within minutes (faster than full review)
- **Gatekeeper warnings:** First launch shows standard "downloaded from internet" warning (expected for all non-App Store apps)
- **Marketing channels:** Must rely on direct marketing, social media, and community rather than App Store presence

**Why This Doesn't Compromise Quality:**

Direct distribution does not mean lower security or quality standards. The application still undergoes:

1. **Developer ID signing:** Cryptographic signature proving developer identity
2. **Notarization:** Apple's automated security analysis scanning for malware and policy violations
3. **Gatekeeper checks:** macOS verifies the app's signature and notarization before first launch
4. **Same binary standards:** Hardened runtime, code signing requirements identical to App Store builds

The primary difference is the absence of manual human review, not the absence of security checks. App Store review primarily enforces guideline compliance (UI/UX standards, business model rules, content policies) rather than discovering security issues that automated tools miss.

**Cost-Benefit Analysis:**

- **Current cost:** $99/year Apple Developer Program (required for notarization and signing)
- **App Store additional cost:** $20/year omg.lol test account (20% overhead)
- **App Store time cost:** 24-48 hours per release (blocks urgent fixes)
- **Development velocity value:** Immediate releases enable faster user feedback and bug fixes

For a single-developer project with an existing account requirement, avoiding the App Store review process provides better ROI through faster iteration and lower operational overhead.

**Related Decisions:**

- Future consideration: Could revisit App Store distribution if user acquisition through App Store becomes strategically valuable
- Potential automation: Could implement Sparkle framework or similar for automated update checks

**Notes:**

This decision prioritizes development velocity and cost efficiency while maintaining identical security standards through code signing and notarization. Direct distribution is a common and legitimate approach for many professional macOS applications (Homebrew, VS Code, Docker Desktop, etc.).
