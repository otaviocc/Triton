import SwiftUI

public extension View {

    /// Applies a card-like appearance to the TextEditor.
    ///
    /// This modifier styles the TextEditor with padding and a rounded border,
    /// giving it a distinct, card-like visual treatment. It's useful for making
    /// text editing areas stand out from the background.
    ///
    /// - Returns: A view with the card styling applied.
    func textEditorCard() -> some View {
        modifier(TextEditorCardModifier())
    }
}

// MARK: - Private

private struct TextEditorCardModifier: ViewModifier {

    // MARK: - Public

    func body(
        content: Content
    ) -> some View {
        content
            .scrollContentBackground(.hidden)
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.accentColor, lineWidth: 1)
                    .opacity(0.3)
            )
    }
}
