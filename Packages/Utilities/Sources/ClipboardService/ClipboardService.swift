import Foundation

/// A protocol defining clipboard operations for copying data.
///
/// `ClipboardServiceProtocol` provides a cross-platform interface for copying
/// text and binary data to the system clipboard, abstracting platform-specific
/// clipboard implementations.
public protocol ClipboardServiceProtocol {

    /// Copies a string to the system clipboard.
    ///
    /// - Parameter string: The text content to copy to the clipboard
    func copy(_ string: String)

    /// Copies binary data to the system clipboard with a specified type.
    ///
    /// - Parameters:
    ///   - data: The binary data to copy to the clipboard
    ///   - type: The UTI (Uniform Type Identifier) or MIME type of the data
    func copy(
        _ data: Data,
        type: String
    )
}

struct ClipboardService: ClipboardServiceProtocol {

    // MARK: - Properties

    private let service: ClipboardServiceProtocol

    // MARK: - Lifecycle

    init(
        service: ClipboardServiceProtocol
    ) {
        self.service = service
    }

    // MARK: - Public

    func copy(_ string: String) {
        service.copy(string)
    }

    func copy(_ data: Data, type: String) {
        service.copy(data, type: type)
    }
}
