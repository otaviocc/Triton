import SwiftUI

public extension Color {

    static let allColors: [Color] = [
        omg0,
        omg1,
        omg2,
        omg3,
        omg4,
        omg5,
        omg6,
        omg7,
        omg8,
        omg9,
        omg10,
        omg11,
        omg12,
        omg13,
        omg14,
        omg15
    ]

    static func color(at position: Int) -> Color {
        let modPosition = position % allColors.count
        let index = modPosition < 0
            ? modPosition + allColors.count
            : modPosition

        return allColors[index]
    }
}
