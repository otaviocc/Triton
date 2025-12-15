#if DEBUG

    import CoreGraphics
    import DesignSystem
    import Foundation
    import ImageIO
    import UniformTypeIdentifiers

    enum DataMother {

        static func makeSquareImageData() -> Data {
            let size = 100
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let context = CGContext(
                data: nil,
                width: size,
                height: size,
                bitsPerComponent: 8,
                bytesPerRow: 0,
                space: colorSpace,
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            )!

            context.setFillColor(red: 0.999, green: 0.410, blue: 0.678, alpha: 1.0)
            context.fill(CGRect(x: 0, y: 0, width: size, height: size))

            let cgImage = context.makeImage()!
            let data = CFDataCreateMutable(nil, 0)!
            let identifier = UTType.png.identifier as CFString
            let destination = CGImageDestinationCreateWithData(data, identifier, 1, nil)!

            CGImageDestinationAddImage(destination, cgImage, nil)
            CGImageDestinationFinalize(destination)

            return data as Data
        }
    }

#endif
