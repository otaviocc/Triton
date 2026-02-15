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

import Foundation

/// A factory protocol for creating clipboard service instances.
///
/// This protocol defines the interface for creating clipboard services that can handle
/// platform-specific clipboard operations. Implementations should provide appropriate
/// clipboard service instances based on the target platform (iOS, macOS, etc.).
///
/// ## Usage
///
/// ```swift
/// let factory: ClipboardServiceFactoryProtocol = ClipboardServiceFactory()
/// let clipboardService = factory.makeClipboardService()
/// ```
public protocol ClipboardServiceFactoryProtocol {

    /// Creates and returns a clipboard service instance.
    ///
    /// This method creates a platform-appropriate clipboard service that conforms to
    /// `ClipboardServiceProtocol`. The returned service handles clipboard operations
    /// specific to the current platform.
    ///
    /// - Returns: A clipboard service instance that conforms to `ClipboardServiceProtocol`.
    func makeClipboardService() -> ClipboardServiceProtocol
}

public struct ClipboardServiceFactory: ClipboardServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeClipboardService() -> any ClipboardServiceProtocol {
        let platformService: ClipboardServiceProtocol

        #if os(iOS)
            platformService = IOSClipboardService()
        #elseif os(macOS)
            platformService = MacOSClipboardService()
        #else
            fatalError("Unsupported platform")
        #endif

        return ClipboardService(
            service: platformService
        )
    }
}
