# ADR-014: SwiftUI-First UI Development

**Status:** Accepted

**Date:** 2025-01-11

**Context:**

When building the macOS application UI, I needed to decide on the UI framework approach. The options were:

1. **AppKit:** Traditional macOS framework with mature APIs
2. **Mixed approach:** SwiftUI with AppKit for specific features
3. **Pure SwiftUI:** SwiftUI exclusively, no AppKit/UIKit

Key considerations:
- **Modern development:** SwiftUI represents Apple's future direction
- **Cross-platform potential:** SwiftUI code could be reused for iOS/iPadOS
- **Declarative UI:** Simpler state management with SwiftUI
- **Consistency:** Single framework approach throughout
- **Learning investment:** SwiftUI is the better long-term investment

**Decision:**

I adopted a pure SwiftUI approach where:

1. **All UI is SwiftUI** - Views, scenes, navigation, everything
2. **No AppKit or UIKit** - Zero usage of legacy frameworks
3. **DesignSystem package** - Shared SwiftUI components and styling
4. **View composition over inheritance** - SwiftUI patterns throughout
5. **SwiftUI-native solutions** - Work within SwiftUI's capabilities

**SwiftUI Usage:**

- **Views:** All feature views built with SwiftUI
- **Navigation:** NavigationSplitView, NavigationStack
- **Scenes:** WindowGroup for auxiliary windows
- **Modifiers:** Custom view modifiers in DesignSystem
- **State management:** @Observable view models (not Combine)
- **Layout:** SwiftUI layout system (VStack, HStack, Grid, etc.)

**DesignSystem Package:**

Central package for reusable UI components:

```swift
// Shared components
- CardViewModifier
- RoundImageModifier
- TextFieldCardModifier
- TextEditorCardModifier
- CircularToolbarModifier

// Toolbar items
- RefreshToolbarItem
- ProgressToolbarItem
- AddressPickerToolbarItem
- SelectionToolbarItem

// Colors and styling
- Consistent color palette
- Shared spacing constants
- Common button styles
```

**View Architecture:**

```swift
// Feature view structure
struct StatusApp: View {
    @State private var viewModel: StatusAppViewModel

    var body: some View {
        VStack {
            makeHeaderView()
            makeContentView()
            makeFooterView()
        }
    }

    @ViewBuilder
    private func makeHeaderView() -> some View {
        // Composed subviews
    }
}
```

**Composition Patterns:**

- **@ViewBuilder methods:** Break down complex views
- **Extracted views:** Separate files for reusable components
- **Modifiers:** Chain modifiers from DesignSystem
- **No massive view bodies:** Keep views readable and composable

**Consequences:**

### Positive

- **Modern codebase:** Using Apple's recommended UI framework exclusively
- **Declarative syntax:** Easier to understand and maintain than imperative frameworks
- **Live previews:** Fast iteration with SwiftUI Previews
- **State management:** Natural integration with @Observable
- **Code reuse:** DesignSystem components shared across features
- **Future-proof:** Aligned with Apple's platform direction
- **Cross-platform potential:** Could port to iOS/iPadOS with minimal changes
- **No framework mixing:** Single mental model throughout codebase
- **Consistency:** All UI follows SwiftUI patterns

### Negative

- **SwiftUI limitations:** Must work within framework capabilities
- **Evolving APIs:** SwiftUI changes across OS versions
- **Learning curve:** Some features require creative SwiftUI solutions

### Neutral

- **API changes:** Need to stay current with SwiftUI evolution
- **Testing:** SwiftUI testing approaches still maturing
- **Performance:** Understanding SwiftUI's performance characteristics

**Design System Benefits:**

- **Consistency:** Shared components ensure uniform UI
- **Maintainability:** Update once, apply everywhere
- **Productivity:** Reusable components speed development
- **Isolation:** Design system can be developed/tested independently

**Related Decisions:**

- [ADR-003: Feature-Based Package Organization](ADR-003-feature-based-package-organization.md) - Each feature contains SwiftUI views
- [ADR-005: Adoption of Swift Observation Framework](ADR-005-adoption-of-swift-observation-framework.md) - @Observable works naturally with SwiftUI
- [ADR-016: SwiftUI Previews with Mother Objects](ADR-016-swiftui-previews-with-mother-objects.md) - Previews enable rapid SwiftUI development

**Notes:**

Pure SwiftUI development provides a consistent, modern approach to UI development. By committing fully to SwiftUI without mixing in AppKit or UIKit, the codebase maintains simplicity and aligns with Apple's platform direction. The DesignSystem package ensures consistency across features, and all UI functionality is achieved using SwiftUI-native solutions.
