import SwiftUI

/// A toolbar item that displays a circular progress indicator.
///
/// `ProgressToolbarItem` provides a consistent progress indicator for toolbars across the application.
/// It uses the `.toolbarButton()` modifier to ensure proper styling and disabled state.
///
/// ## Usage
///
/// ```swift
/// .toolbar {
///     ToolbarItemGroup {
///         if isLoading {
///             ProgressToolbarItem()
///         }
///         // Other toolbar items...
///     }
/// }
/// ```
///
/// - Note: This component is automatically disabled and styled to fit toolbar contexts.
public struct ProgressToolbarItem: View {

    // MARK: - Lifecycle

    /// Creates a progress toolbar item.
    public init() {}

    // MARK: - Public

    public var body: some View {
        ProgressView()
            .toolbarButton()
    }
}

// MARK: - Preview

#Preview {
    ProgressToolbarItem()
}
