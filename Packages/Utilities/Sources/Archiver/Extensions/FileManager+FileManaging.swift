import Foundation

public protocol FileManaging {

    @discardableResult
    func createFile(
        atPath path: String,
        contents data: Data?,
        attributes attr: [FileAttributeKey: Any]?
    ) -> Bool

    func contents(atPath path: String) -> Data?
    func removeItem(at URL: URL) throws
    func removeItem(atPath path: String) throws
    func fileExists(atPath path: String) -> Bool

    func containerURL(
        forSecurityApplicationGroupIdentifier groupIdentifier: String
    ) -> URL?

    func urls(
        for directory: FileManager.SearchPathDirectory,
        in domainMask: FileManager.SearchPathDomainMask
    ) -> [URL]
}

// MARK: - FileManaging

extension FileManager: FileManaging {}
