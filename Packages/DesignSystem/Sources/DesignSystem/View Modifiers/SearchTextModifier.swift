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

public extension TextField {

    /// Adds search functionality to a TextField with a clear button.
    ///
    /// This modifier enhances a TextField by adding a rounded border style and an optional
    /// clear button (X) that appears when there is text in the search field. The clear button
    /// allows users to quickly empty the search field.
    ///
    /// - Parameter searchTerm: A binding to the string that holds the current search text.
    ///
    /// - Returns: A view that combines the text field with search functionality.
    ///
    /// ## Example
    /// ```swift
    /// struct SearchView: View {
    ///     @State private var searchText = ""
    ///
    ///     var body: some View {
    ///         TextField("Search...", text: $searchText)
    ///             .search(searchTerm: $searchText)
    ///     }
    /// }
    /// ```
    func search(
        searchTerm: Binding<String>
    ) -> some View {
        modifier(
            SearchTextModifier(
                searchTerm: searchTerm
            )
        )
    }
}

// MARK: - Private

private struct SearchTextModifier: ViewModifier {

    // MARK: - Properties

    @Binding var searchTerm: String

    // MARK: - Public

    func body(
        content: Content
    ) -> some View {
        ZStack(alignment: .trailing) {
            content
                .textFieldCard()

            if !searchTerm.isEmpty {
                Button {
                    searchTerm = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .padding(.trailing, 20)
                .help("Clear search")
                .buttonStyle(.borderless)
                .frame(width: 20, height: 20)
            }
        }
    }
}
