import SwiftUI

public extension View {

    /// Applies card styling with a background color selected by ID.
    ///
    /// This modifier wraps the view in a card-style container with padding and a rounded
    /// rectangle background. The background color is determined by a color ID which maps
    /// to a predefined color in the design system.
    ///
    /// - Parameter colorID: An integer ID that maps to a specific color in the color palette.
    ///
    /// - Returns: A view styled as a card with the specified background color.
    ///
    /// ## Example
    /// ```swift
    /// Text("Card Content")
    ///     .card(3) // Uses color at index 3
    /// ```
    func card(
        _ colorID: Int
    ) -> some View {
        modifier(
            CardViewModifier(
                fill: .colorID(colorID)
            )
        )
    }

    /// Applies card styling with a custom background color.
    ///
    /// This modifier wraps the view in a card-style container with padding and a rounded
    /// rectangle background using the specified color.
    ///
    /// - Parameter color: The background color for the card.
    ///
    /// - Returns: A view styled as a card with the specified background color.
    ///
    /// ## Example
    /// ```swift
    /// Text("Card Content")
    ///     .card(.blue)
    /// ```
    func card(
        _ color: Color
    ) -> some View {
        modifier(
            CardViewModifier(
                fill: .color(color)
            )
        )
    }
}

// MARK: - Private

private struct CardViewModifier: ViewModifier {

    // MARK: - Nested types

    enum Fill {

        case color(Color)
        case colorID(Int)

        var color: Color {
            switch self {
            case let .color(color): color
            case let .colorID(id): Color.color(at: id)
            }
        }
    }

    // MARK: - Properties

    let fill: Fill

    // MARK: - Public

    func body(
        content: Content
    ) -> some View {
        content
            .padding()
            .background(
                fill.color,
                in: RoundedRectangle(cornerRadius: 8)
            )
    }
}
