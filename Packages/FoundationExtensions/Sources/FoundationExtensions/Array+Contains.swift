import Foundation

public extension [String] {

    /// Determines whether the array contains any string element that partially matches the specified string.
    ///
    /// This method performs a case-insensitive, locale-aware search to find if any string in the array
    /// contains the given partial string as a substring.
    ///
    /// - Parameter partial: The substring to search for within the array elements.
    /// - Returns: `true` if any element in the array contains the partial string; otherwise, `false`.
    func containsPartial(_ partial: String) -> Bool {
        contains { $0.localizedCaseInsensitiveContains(partial) }
    }
}
