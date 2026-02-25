// MIT License
//
// Copyright (c) 2026 Otávio Cordeiro
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
            Label {
                Text("Refresh")
            } icon: {
                Image(systemName: "arrow.counterclockwise")
                    .rotationEffect(.degrees(isDisabled ? -360 : 0))
                    .animation(
                        isDisabled
                            ? .linear(duration: 1).repeatForever(autoreverses: false)
                            : .default,
                        value: isDisabled
                    )
            }
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
