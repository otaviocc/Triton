import SwiftUI

/// A customizable dropdown menu view that allows users to select from a list of options.
///
/// `DropdownMenuView` provides a SwiftUI Menu-based dropdown with support for both text labels
/// and custom view labels. Selected items are indicated with a checkmark.
///
/// ## Usage
///
/// ### With text label:
/// ```swift
/// DropdownMenuView(
///     "Select User",
///     options: ["alice", "bob", "charlie"],
///     selection: $selectedUser
/// )
/// ```
///
/// ### With custom label:
/// ```swift
/// DropdownMenuView(
///     options: users,
///     selection: $selectedUser
/// ) {
///     Image(systemName: "person.circle")
/// }
/// ```
///
/// - Note: The generic `Item` type must conform to `Hashable` for ForEach iteration.
public struct DropdownMenuView<Item: Hashable>: View {

    // MARK: - Properties

    private let title: LocalizedStringKey
    private let options: [Item]
    private let selection: Binding<Item>
    private let customLabel: AnyView?
    private let itemLabel: (Item) -> String

    // MARK: - Lifecycle

    /// Creates a dropdown menu with a text label.
    ///
    /// - Parameters:
    ///   - title: The localized string key used as the menu's button label.
    ///   - options: An array of selectable items that conform to `Hashable`.
    ///   - selection: A binding to the currently selected item.
    ///   - itemLabel: A closure that converts each item to its display string.
    ///                Defaults to `String(describing:)` if not provided.
    public init(
        _ title: LocalizedStringKey,
        options: [Item],
        selection: Binding<Item>,
        itemLabel: @escaping (Item) -> String = { String(describing: $0) }
    ) {
        customLabel = nil
        self.title = title
        self.options = options
        self.selection = selection
        self.itemLabel = itemLabel
    }

    /// Creates a dropdown menu with a custom view label.
    ///
    /// - Parameters:
    ///   - options: An array of selectable items that conform to `Hashable`.
    ///   - selection: A binding to the currently selected item.
    ///   - itemLabel: A closure that converts each item to its display string.
    ///                Defaults to `String(describing:)` if not provided.
    ///   - label: A ViewBuilder closure that creates the custom menu button content.
    public init(
        options: [Item],
        selection: Binding<Item>,
        itemLabel: @escaping (Item) -> String = { String(describing: $0) },
        @ViewBuilder label: () -> some View
    ) {
        title = ""
        customLabel = AnyView(label())
        self.options = options
        self.selection = selection
        self.itemLabel = itemLabel
    }

    // MARK: - Public

    public var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button {
                    selection.wrappedValue = option
                } label: {
                    if selection.wrappedValue == option {
                        Label(itemLabel(option), systemImage: "checkmark")
                    } else {
                        Text(itemLabel(option))
                    }
                }
            }
        } label: {
            if let customLabel {
                customLabel
            } else {
                Text(title)
            }
        }
    }
}

// MARK: - Preview

#Preview("Text label") {
    DropdownMenuView(
        "Pick something",
        options: ["otaviocc", "adam", "prami"],
        selection: .constant("otaviocc")
    )
}

#Preview("Custom icon label") {
    DropdownMenuView(
        options: ["otaviocc", "adam", "prami"],
        selection: .constant("adam")
    ) {
        Image(systemName: "person.circle")
    }
}
