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
            Label("Address", systemImage: "person.circle")
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
