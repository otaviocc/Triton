import SwiftUI

/// A toolbar item that displays a refresh button with customizable action and state.
///
/// `RefreshToolbarItem` provides a consistent refresh button for toolbars across the application.
/// It uses the standard counterclockwise arrow icon and supports custom help text and disabled states.
/// When the button is disabled, which typically indicates a refresh operation is in progress,
/// the icon will animate with a rotation effect.
///
/// ## Usage
///
/// ```swift
/// .toolbar {
///     ToolbarItemGroup {
///         RefreshToolbarItem(
///             action: { viewModel.fetchData() },
///             helpText: "Refresh data",
///             isDisabled: viewModel.isLoading
///         )
///     }
/// }
/// ```
///
/// - Note: The help text parameter accepts `LocalizedStringKey` for automatic localization support.
public struct RefreshToolbarItem: View {

    // MARK: - Properties

    private let action: () -> Void
    private let helpText: LocalizedStringKey
    private let isDisabled: Bool

    // MARK: - Lifecycle

    /// Creates a refresh toolbar item.
    ///
    /// - Parameters:
    ///   - action: The closure to execute when the refresh button is tapped.
    ///   - helpText: The localized help text displayed on hover. Defaults to "Refresh".
    ///   - isDisabled: Whether the button should be disabled. When `true`, the icon animates. Defaults to `false`.
    public init(
        action: @escaping () -> Void,
        helpText: LocalizedStringKey = "Refresh",
        isDisabled: Bool = false
    ) {
        self.action = action
        self.helpText = helpText
        self.isDisabled = isDisabled
    }

    // MARK: - Public

    public var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "arrow.counterclockwise")
                .rotationEffect(.degrees(isDisabled ? -360 : 0))
                .animation(
                    isDisabled
                        ? .linear(duration: 1).repeatForever(autoreverses: false)
                        : .default,
                    value: isDisabled
                )
        }
        .help(helpText)
        .disabled(isDisabled)
    }
}

// MARK: - Preview

#Preview("Enabled") {
    RefreshToolbarItem(
        action: { print("Refresh tapped") },
        helpText: "Refresh data"
    )
}

#Preview("Disabled and Animating") {
    RefreshToolbarItem(
        action: { print("Refresh tapped") },
        helpText: "Refresh data",
        isDisabled: true
    )
}
