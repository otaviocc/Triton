import StatusPersistenceService
import StatusRepository
import SwiftData
import SwiftUI

struct StatusListView: View {

    // MARK: - Properties

    @State private var viewModel: StatusListViewModel
    @Environment(\.viewModelFactory) private var viewModelFactory
    @Query private var statuses: [Status]
    @Query private var mutedAddresses: [MutedAddress]
    @Query private var mutedKeywords: [MutedKeyword]

    // MARK: - Lifecycle

    init(
        viewModel: StatusListViewModel
    ) {
        self.viewModel = viewModel

        _statuses = .init(viewModel.fetchDescriptor())
    }

    // MARK: - Computed Properties

    private var filteredStatuses: [Status] {
        let addressSet = Set(mutedAddresses.map(\.address))
        let keywords = mutedKeywords.map(\.keyword)

        return statuses.filter {
            !$0.shouldFilter(
                mutedAddresses: addressSet,
                mutedKeywords: keywords
            )
        }
    }

    // MARK: - Public

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(filteredStatuses, id: \.id) { status in
                    StatusContainer(status: status)
                }
            }
            .padding(8)
        }
    }
}

// MARK: - Private

private struct StatusContainer: View {

    // MARK: - Properties

    let status: Status
    @Environment(\.viewModelFactory) private var viewModelFactory

    // MARK: - Public

    var body: some View {
        let viewModel = viewModelFactory.makeStatusViewModel(
            status: status
        )

        StatusView(viewModel: viewModel)
    }
}

// MARK: - Preview

#if DEBUG

    #Preview {
        let repository = StatusRepositoryMother.makeStatusRepository()
        let environment = StatusEnvironmentMother.makeStatusEnvironment()

        StatusListView(
            viewModel: .init(filter: .all)
        )
        .environment(\.viewModelFactory, environment.viewModelFactory)
        .modelContainer(repository.statusesContainer)
        .frame(width: 360)
    }

#endif
