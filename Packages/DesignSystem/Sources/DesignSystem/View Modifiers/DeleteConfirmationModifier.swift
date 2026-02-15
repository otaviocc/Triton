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

public extension View {

    /// Presents a confirmation dialog for delete operations.
    ///
    /// This modifier adds a confirmation dialog that appears when the user attempts to delete something,
    /// providing a safety mechanism to prevent accidental deletions. The dialog includes a destructive
    /// "Delete" button and automatically handles the confirmation flow.
    ///
    /// - Parameters:
    ///   - isPresented: A binding that controls when the confirmation dialog is shown.
    ///   - title: The main title displayed in the confirmation dialog. Defaults to "Are you sure?".
    ///   - message: An optional message providing additional context about the deletion. Defaults to
    ///   "You can’t undo this action."
    ///   - action: The closure to execute when the user confirms the deletion.
    ///
    /// - Returns: A view that presents a delete confirmation dialog when needed.
    ///
    /// ## Example
    /// ```swift
    /// struct ContentView: View {
    ///     @State private var showDeleteConfirmation = false
    ///
    ///     var body: some View {
    ///         Button("Delete Item") {
    ///             showDeleteConfirmation = true
    ///         }
    ///         .deleteConfirmation(
    ///             isPresented: $showDeleteConfirmation,
    ///             title: "Delete Item?",
    ///             message: "This item will be permanently removed."
    ///         ) {
    ///             // Perform deletion
    ///             deleteItem()
    ///         }
    ///     }
    /// }
    /// ```
    func deleteConfirmation(
        isPresented: Binding<Bool>,
        title: String = "Are you sure?",
        message: String? = "You can’t undo this action.",
        action: @escaping () -> Void
    ) -> some View {
        modifier(
            DeleteConfirmationModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                deleteAction: action
            )
        )
    }
}

// MARK: - Private

private struct DeleteConfirmationModifier: ViewModifier {

    // MARK: - Properties

    @Binding private var isPresented: Bool

    private let title: String
    private let message: String?
    private let deleteAction: () -> Void

    // MARK: - Lifecycle

    init(
        isPresented: Binding<Bool>,
        title: String,
        message: String?,
        deleteAction: @escaping () -> Void
    ) {
        _isPresented = isPresented

        self.title = title
        self.message = message
        self.deleteAction = deleteAction
    }

    // MARK: - Public

    func body(content: Content) -> some View {
        content
            .confirmationDialog(
                title,
                isPresented: $isPresented,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    deleteAction()
                }
            } message: {
                if let message {
                    Text(message)
                }
            }
    }
}
