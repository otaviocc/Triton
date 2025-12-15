import SwiftUI

/// A label style that controls the spacing between the icon and title.
///
/// `DistancedLabelStyle` arranges the label's icon and title horizontally
/// with a customizable distance between them, aligned to the first text baseline.
public struct DistancedLabelStyle: LabelStyle {

    // MARK: - Properties

    private let distance: CGFloat

    // MARK: - Lifecycle

    /// Creates a label style with the specified spacing.
    ///
    /// - Parameter distance: The horizontal spacing between the icon and title in points.
    public init(
        distance: CGFloat
    ) {
        self.distance = distance
    }

    // MARK: - Public

    public func makeBody(
        configuration: Configuration
    ) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: distance) {
            configuration.icon
            configuration.title
        }
    }
}

public extension LabelStyle where Self == DistancedLabelStyle {

    // MARK: - Public

    static func distanced(
        _ distance: CGFloat
    ) -> DistancedLabelStyle {
        .init(distance: distance)
    }

    static var distanced: DistancedLabelStyle {
        .init(distance: 2)
    }
}

// MARK: - Preview

#Preview("Default value of 2") {
    Label("Safari", systemImage: "safari")
        .labelStyle(.distanced)
}

#Preview("Value set to 2") {
    Label("Safari", systemImage: "safari")
        .labelStyle(.distanced(2))
}

#Preview("Value set to 12") {
    Label("Safari", systemImage: "safari")
        .labelStyle(.distanced(12))
}
