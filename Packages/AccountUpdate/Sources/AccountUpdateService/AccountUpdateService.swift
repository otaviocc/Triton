import AccountUpdateRepository
import Observation

@Observable
public final class AccountUpdateService {

    // MARK: - Properties

    private let updateRepository: AccountUpdateRepositoryProtocol

    // MARK: - Lifecycle

    init(
        updateRepository: AccountUpdateRepositoryProtocol
    ) {
        self.updateRepository = updateRepository
    }
}
