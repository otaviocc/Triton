import CoreGraphics
import Foundation
import ImageIO

public extension Data {

    /// Creates a CGImage from the data.
    ///
    /// - Returns: A CGImage created from the data, or nil if the data cannot be converted to an image.
    var cgImage: CGImage? {
        guard let imageSource = CGImageSourceCreateWithData(self as CFData, nil) else {
            return nil
        }

        return CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
    }
}
