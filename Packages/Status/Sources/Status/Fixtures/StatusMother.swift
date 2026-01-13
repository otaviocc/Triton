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
            for index in 0..<count {
                let status = Status(
                    username: "user\(index)",
                    statusID: "(index)",
                    timestamp: Double(index),
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
