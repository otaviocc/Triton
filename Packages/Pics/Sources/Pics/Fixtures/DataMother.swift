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
