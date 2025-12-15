enum PastesListSort: Int, CaseIterable, Hashable, Identifiable {

    case titleAscending
    case titleDescending
    case modifiedNewest
    case modifiedOldest

    // MARK: - Properties

    static let key = String(
        describing: Self.self
    )

    var id: Self { self }

    var localizedTitle: String {
        switch self {
        case .titleAscending: "Title A–Z"
        case .titleDescending: "Title Z–A"
        case .modifiedNewest: "Recently Updated"
        case .modifiedOldest: "Oldest Updated"
        }
    }
}
