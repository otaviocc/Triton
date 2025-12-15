enum StatusListFilter: Int, CaseIterable, Hashable, Identifiable {

    case all
    case thisMonth
    case thisWeek
    case today

    // MARK: - Properties

    static let key = String(
        describing: Self.self
    )

    var id: Self { self }

    var localizedTitle: String {
        switch self {
        case .all: "All"
        case .thisMonth: "This Month"
        case .thisWeek: "This Week"
        case .today: "Today"
        }
    }
}
