import SwiftUI

public extension View {

    /// Applies a card-like appearance to a view, intended for wrapping TextFields.
    ///
    /// This modifier styles the content with padding and a rounded border,
    /// giving it a distinct, card-like visual treatment. It also applies styling
    /// specific to TextFields.
    ///
    /// - Returns: A view with the card styling applied.
    func textFieldCard() -> some View {
        modifier(TextFieldCardModifier())
    }
}

// MARK: - Private

private struct TextFieldCardModifier: ViewModifier {

    // MARK: - Public

    func body(
        content: Content
    ) -> some View {
        content
            .textFieldStyle(.plain)
            .focusEffectDisabled()
            .scrollContentBackground(.hidden)
            .padding(12)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.accentColor, lineWidth: 1)
                    .opacity(0.3)
            )
    }
}
