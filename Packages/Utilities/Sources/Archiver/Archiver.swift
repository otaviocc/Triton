import Foundation

/// A protocol for archiving and retrieving Codable items to/from persistent storage.
///
/// The `Archiving` protocol provides a type-safe interface for persisting Codable items
/// to disk and retrieving them later. It supports a single-item archival model where
/// each archive operation replaces any previously stored data.
///
/// ## Usage
///
/// Conforming types should handle JSON encoding/decoding and file system operations
/// internally, providing a clean async interface for clients:
///
/// ```swift
/// let archiver = Archiver<MyModel>()
///
/// // Archive an item (overwrites existing data)
/// try await archiver.archiveItem(myModel)
///
/// // Retrieve the archived item
/// let retrieved = try await archiver.unarchiveItem()
///
/// // Clear stored data
/// try await archiver.clearArchive()
/// ```
///
/// ## Thread Safety
///
/// All methods are async and should be implemented in a thread-safe manner.
/// The provided `Archiver` implementation uses Swift's actor model for safety.
///
/// ## Error Handling
///
/// Methods may throw errors for file system operations, encoding/decoding failures,
/// or when attempting to unarchive non-existent data.
public protocol Archiving {

    /// The type of item that can be archived. Must be both Codable for serialization
    /// and Sendable for safe concurrent access.
    associatedtype Item: Codable & Sendable

    /// Archives the specified item to persistent storage.
    ///
    /// This operation completely replaces any previously archived data for this type.
    /// The item is JSON-encoded and written to a type-specific file location.
    ///
    /// - Parameter item: The item to archive. Must conform to the associated `Item` type.
    /// - Throws: `ArchiverError` or file system errors if the archival operation fails.
    func archiveItem(
        _ item: Item
    ) async throws

    /// Retrieves and decodes the previously archived item.
    ///
    /// Reads the archived JSON data from disk and decodes it back to the original type.
    ///
    /// - Returns: The unarchived item of type `Item`.
    /// - Throws: `ArchiverError.empty` if no archived data exists, or decoding errors
    ///   if the stored data cannot be decoded to the expected type.
    func unarchiveItem() async throws -> Item

    /// Removes all archived data from persistent storage.
    ///
    /// Deletes the archive file from disk, effectively clearing all stored data
    /// for this archive instance. Subsequent calls to `unarchiveItem()` will
    /// throw `ArchiverError.empty` until new data is archived.
    ///
    /// - Throws: File system errors if the deletion operation fails.
    func clearArchive() async throws
}

public actor Archiver<ArchivableType>: Archiving where ArchivableType: Codable & Sendable {

    public typealias Item = ArchivableType

    // MARK: - Properties

    private let fileManager: FileManaging
    private let eventsFileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    // MARK: - Lifecycle

    public init(
        appGroupName: String? = nil,
        fileManager: FileManaging = FileManager.default,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) throws {
        self.fileManager = fileManager
        self.encoder = encoder
        self.decoder = decoder

        guard
            let directoryURL = localDirectoryURL(for: appGroupName, fileManager: fileManager)
        else {
            throw ArchiverError.noDirectoryURL
        }

        eventsFileURL = directoryURL
            .appendingPathComponent("archiver\(String(describing: Item.self))Item")
            .appendingPathExtension("json")
    }

    // MARK: - Public

    public func archiveItem(
        _ item: Item
    ) async throws {
        let data = try encoder.encode(item)

        try await clearArchive()

        _ = fileManager.createFile(
            atPath: eventsFileURL.path,
            contents: data, attributes: nil
        )
    }

    public func unarchiveItem() async throws -> Item {
        guard
            fileManager.fileExists(atPath: eventsFileURL.path),
            let data = fileManager.contents(atPath: eventsFileURL.path)
        else {
            throw ArchiverError.empty
        }

        return try decoder.decode(Item.self, from: data)
    }

    public func clearArchive() async throws {
        if fileManager.fileExists(atPath: eventsFileURL.path) {
            try fileManager.removeItem(at: eventsFileURL)
        }
    }
}

// MARK: - Private

private func localDirectoryURL(
    for appGroupName: String?,
    fileManager: FileManaging
) -> URL? {
    guard let appGroupName else {
        return fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first
    }

    return fileManager.containerURL(
        forSecurityApplicationGroupIdentifier: appGroupName
    )
}
