import Foundation

public extension URL {

    /// Creates a preview URL by appending `.preview` before the file extension.
    ///
    /// This property generates a preview version of an image URL by inserting
    /// `.preview` between the filename and its extension. This is commonly used
    /// for generating thumbnail or preview versions of images.
    ///
    /// - Returns: A new URL with `.preview` inserted before the file extension
    /// - Example: `https://cdn.some.pics/user/image.jpg` → `https://cdn.some.pics/user/image.preview.jpg`
    var imagePreviewURL: URL {
        let pathExtension = pathExtension
        let lastPathComponent = lastPathComponent
        let baseURL = deletingLastPathComponent()

        let filenameWithoutExtension = String(
            lastPathComponent.dropLast(pathExtension.count + (pathExtension.isEmpty ? 0 : 1))
        )

        let newFilename = if pathExtension.isEmpty {
            "\(filenameWithoutExtension).preview"
        } else {
            "\(filenameWithoutExtension).preview.\(pathExtension)"
        }

        return baseURL.appendingPathComponent(newFilename)
    }
}
