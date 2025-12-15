import Foundation

enum ArchiverError: LocalizedError {

    case noDirectoryURL
    case empty

    var errorDescription: String? {
        switch self {
        case .noDirectoryURL:
            "Failed to initialize Archiver. Directory not found."
        case .empty:
            "Nothing found in the archive."
        }
    }
}
