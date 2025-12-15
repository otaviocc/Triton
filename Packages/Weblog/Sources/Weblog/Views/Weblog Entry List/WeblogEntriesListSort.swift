enum WeblogEntriesListSort: Int, CaseIterable, Hashable, Identifiable {

    case titleAscending
    case titleDescending
    case publishedDateDescending
    case publishedDateAscending

    // MARK: - Properties

    static let key = String(
        describing: Self.self
    )

    var id: Self { self }

    var localizedTitle: String {
        switch self {
        case .titleAscending: "Title A–Z"
        case .titleDescending: "Title Z–A"
        case .publishedDateDescending: "Newest First"
        case .publishedDateAscending: "Oldest First"
        }
    }
}
