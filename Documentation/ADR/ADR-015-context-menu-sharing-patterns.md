# ADR-015: Context Menu Sharing Patterns

**Status:** Accepted

**Date:** 2025-01-11

**Context:**

Content items throughout the application (PURLs, pictures, weblog entries, pastes) need consistent sharing capabilities. Users should be able to:

1. **Copy URLs** in various formats (plain URL, Markdown)
2. **Share externally** using system share sheet
3. **Share internally** to Statuslog
4. **Manage items** with edit/delete actions

I needed to establish a consistent pattern for context menus that would:
- Provide intuitive sharing options
- Maintain consistency across features
- Use native macOS patterns
- Be easy to implement in new features

**Decision:**

I adopted a standardized context menu structure using SwiftUI's native `ShareLink` for external sharing, combined with custom copy and internal sharing actions.

**Context Menu Structure:**

All content item views follow this consistent ordering:

1. **Edit/Management actions** (e.g., Edit, Modify)
2. **Copy options** (URL, Markdown formats)
3. **Native ShareLink** - System share sheet
4. **Internal sharing** (Share on Statuslog)
5. **Delete actions** (destructive, at bottom)

**Views with Context Menus:**

- `PURLView` - PURL management with `viewModel.permanentURL`
- `PictureView` - Picture sharing with `viewModel.somePicsURL`
- `WeblogEntryView` - Blog post sharing with `viewModel.permanentURL`
- `PasteView` - Paste sharing with `viewModel.permanentURL` (public pastes only)

**ShareLink Implementation:**

```swift
@ViewBuilder
private func makeShareMenuItem() -> some View {
    ShareLink(item: viewModel.permanentURL) {
        Label("Share", systemImage: "square.and.arrow.up")
    }
}
```

**Complete Context Menu Example:**

```swift
struct PURLView: View {
    @State private var viewModel: PURLViewModel

    var body: some View {
        // ... view content ...
            .contextMenu {
                // 1. Edit/Management actions
                Button("Edit") {
                    viewModel.edit()
                }

                Divider()

                // 2. Copy options
                Button("Copy URL") {
                    viewModel.copyURL()
                }

                Button("Copy as Markdown") {
                    viewModel.copyAsMarkdown()
                }

                Divider()

                // 3. Native ShareLink
                ShareLink(item: viewModel.permanentURL) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }

                Divider()

                // 4. Internal sharing
                Button("Share on Statuslog") {
                    viewModel.shareOnStatuslog()
                }

                Divider()

                // 5. Delete actions (destructive)
                Button("Delete", role: .destructive) {
                    viewModel.delete()
                }
            }
    }
}
```

**Copy Format Conventions:**

- **Copy URL:** Plain URL string for pasting anywhere
- **Copy as Markdown:** `[Title](URL)` format for documentation
- **Copy as Rich Text:** Formatted text with embedded link (when applicable)

**ShareLink Benefits:**

1. **Native integration:** Uses macOS share sheet
2. **System services:** Access to Mail, Messages, AirDrop, etc.
3. **User familiarity:** Standard macOS sharing experience
4. **No custom code:** SwiftUI provides implementation
5. **Consistent icon:** `square.and.arrow.up` system symbol

**Internal Sharing Pattern:**

"Share on Statuslog" creates a status update with the item's URL:
- Provides cross-feature integration
- Encourages content discovery
- Maintains context within the application

**Consequences:**

### Positive

- **Consistency:** All content items share similar interaction patterns
- **Discoverability:** Context menus make sharing obvious
- **Native feel:** ShareLink provides standard macOS experience
- **Flexibility:** Multiple copy formats serve different use cases
- **Maintenance:** Pattern is easy to replicate in new features

### Negative

- **Repetition:** Similar code across multiple views (mitigated by view model methods)
- **Menu length:** Full menu can be lengthy with all options

### Neutral

- **Menu order:** Established order must be maintained for consistency
- **Feature parity:** New content types should follow same pattern

**Implementation Guidelines:**

1. **Always include ShareLink** - Provide native system sharing
2. **Maintain consistent ordering** - Follow the five-section structure
3. **Use dividers** - Separate logical groups of actions
4. **Destructive actions last** - Delete always at bottom with `.destructive` role
5. **View model methods** - Keep logic in view model, not view

**Accessibility:**

- Label text clearly describes action
- System icons provide visual recognition
- Keyboard shortcuts for common actions
- VoiceOver-friendly labels

**Related Decisions:**

- [ADR-014: SwiftUI-First UI Development](ADR-014-swiftui-first-ui-development.md) - ShareLink is SwiftUI-native
- [ADR-003: Feature-Based Package Organization](ADR-003-feature-based-package-organization.md) - Pattern implemented across features

**Notes:**

The standardized context menu pattern with ShareLink provides a consistent, native sharing experience across all content types. By establishing clear conventions for menu structure and actions, new features can easily maintain consistency with existing patterns. The use of SwiftUI's ShareLink ensures the app feels native to macOS while providing powerful sharing capabilities.
