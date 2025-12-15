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

    // MARK: - Public

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(filteredStatuses(), id: \.self) { status in
                    StatusView(
                        viewModel: viewModelFactory.makeStatusViewModel(
                            status: status
                        )
                    )
                }
            }
            .padding(8)
        }
    }

    // MARK: - Private

    private func filteredStatuses() -> [Status] {
        let addressSet = Set(mutedAddresses.map(\.address))
        let keywords = mutedKeywords.map(\.keyword)

        return statuses.filter {
            !$0.shouldFilter(
                mutedAddresses: addressSet,
                mutedKeywords: keywords
            )
        }
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
