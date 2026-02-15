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

/// Factory protocol for creating `ShortcutsService` instances.
///
/// This factory provides dependency injection for the shortcuts service layer,
/// allowing test doubles to be substituted in test environments while maintaining
/// the same interface.
///
/// ## Usage
///
/// Factories are typically resolved through the dependency injection container
/// and used to create service instances with their dependencies properly configured:
///
/// ```swift
/// let factory: ShortcutsServiceFactoryProtocol = // ... from container
/// let service = factory.makeShortcutsServiceService()
/// service.setUpObservers(openWindow: openWindow)
/// ```
public protocol ShortcutsServiceFactoryProtocol {

    /// Creates a configured shortcuts service instance.
    ///
    /// The returned service is ready to observe App Intent notifications and coordinate
    /// window opening actions. It is configured with the default notification center for
    /// production use.
    ///
    /// - Returns: A fully configured service conforming to `ShortcutsServiceProtocol`
    func makeShortcutsService() -> ShortcutsServiceProtocol
}

public struct ShortcutsServiceFactory: ShortcutsServiceFactoryProtocol {

    // MARK: - Lifecycle

    public init() {}

    // MARK: - Public

    public func makeShortcutsService() -> any ShortcutsServiceProtocol {
        ShortcutsService(
            notificationCenter: NotificationCenter.default
        )
    }
}
