enum PURLsListSort: Int, CaseIterable, Hashable, Identifiable {

    case nameAscending
    case nameDescending
    case domainAscending
    case domainDescending

    // MARK: - Properties

    static let key = String(
        describing: Self.self
    )

    var id: Self { self }

    var localizedTitle: String {
        switch self {
        case .nameAscending: "Name A–Z"
        case .nameDescending: "Name Z–A"
        case .domainAscending: "Domain A–Z"
        case .domainDescending: "Domain Z–A"
        }
    }
}
