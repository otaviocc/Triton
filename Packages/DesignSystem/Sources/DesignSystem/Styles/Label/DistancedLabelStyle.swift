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
