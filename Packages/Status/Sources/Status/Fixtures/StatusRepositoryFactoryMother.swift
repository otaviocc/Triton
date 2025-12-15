#if DEBUG

    import StatusNetworkService
    import StatusPersistenceService
    import StatusRepository

    enum StatusRepositoryFactoryMother {

        // MARK: - Nested types

        private struct FakeStatusRepositoryFactory: StatusRepositoryFactoryProtocol {

            func makeStatusRepository(
                networkService: StatusNetworkServiceProtocol,
                persistenceService: StatusPersistenceServiceProtocol
            ) -> StatusRepositoryProtocol {
                StatusRepositoryMother.makeStatusRepository()
            }
        }

        // MARK: - Public

        static func makeStatusRepositoryFactory() -> StatusRepositoryFactoryProtocol {
            FakeStatusRepositoryFactory()
        }
    }

#endif
