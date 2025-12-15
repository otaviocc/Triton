import SwiftUI

/// A toolbar item that displays an address picker dropdown menu.
///
/// `AddressPickerToolbarItem` provides a consistent address selection interface for toolbars
/// across the application. It uses a person.circle icon and displays a dropdown menu of available addresses.
///
/// ## Usage
///
/// ```swift
/// .toolbar {
///     ToolbarItemGroup {
///         if showAddressesPicker {
///             AddressPickerToolbarItem(
///                 addresses: viewModel.addresses,
///                 selection: $viewModel.selectedAddress,
///                 helpText: "Select address for paste"
///             )
///         }
///     }
/// }
/// ```
///
/// - Note: The generic `Address` type must conform to `Hashable` for the dropdown menu to work properly.
public struct AddressPickerToolbarItem<Address: Hashable>: View {

    // MARK: - Properties

    private let addresses: [Address]
    private let selection: Binding<Address>
    private let helpText: LocalizedStringKey

    // MARK: - Lifecycle

    /// Creates an address picker toolbar item.
    ///
    /// - Parameters:
    ///   - addresses: An array of available addresses to choose from.
    ///   - selection: A binding to the currently selected address.
    ///   - helpText: The localized help text displayed on hover. Defaults to "Select address".
    public init(
        addresses: [Address],
        selection: Binding<Address>,
        helpText: LocalizedStringKey = "Select address"
    ) {
        self.addresses = addresses
        self.selection = selection
        self.helpText = helpText
    }

    // MARK: - Public

    public var body: some View {
        DropdownMenuView(
            options: addresses,
            selection: selection
        ) {
            Image(systemName: "person.circle")
                .help(helpText)
        }
    }
}

// MARK: - Preview

#Preview {
    AddressPickerToolbarItem(
        addresses: ["alice", "bob", "charlie"],
        selection: .constant("alice"),
        helpText: "Select posting address"
    )
}
