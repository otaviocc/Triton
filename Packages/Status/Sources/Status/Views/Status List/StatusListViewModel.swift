import Foundation
import Observation
import StatusPersistenceService
import StatusRepository
import SwiftData

@MainActor
@Observable
final class StatusListViewModel {

    // MARK: - Properties

    private var filter: StatusListFilter

    // MARK: - Lifecycle

    init(
        filter: StatusListFilter
    ) {
        self.filter = filter
    }

    // MARK: - Public

    func fetchDescriptor() -> FetchDescriptor<Status> {
        let dateFilter = convertToDateFilter(filter)
        return .makeFiltered(by: dateFilter)
    }

    // MARK: - Private

    private func convertToDateFilter(
        _ filter: StatusListFilter
    ) -> FetchDescriptor<Status>.DateFilter {
        switch filter {
        case .all: .all
        case .today: .today
        case .thisWeek: .thisWeek
        case .thisMonth: .thisMonth
        }
    }
}
