#if DEBUG

    import StatusPersistenceService
    import SwiftData

    extension Status {

        // MARK: - Public

        @MainActor
        static func makeStatus(
            count: Int,
            in container: ModelContainer
        ) {
            for i in 0..<count {
                let status = Status(
                    username: "user\(i)",
                    statusID: "(i)",
                    timestamp: Double(i),
                    icon: "🤣",
                    content: "Nulla purus urna, bibendum nec purus."
                )

                container.mainContext.insert(
                    status
                )
            }
        }
    }

#endif
