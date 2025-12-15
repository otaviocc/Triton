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
