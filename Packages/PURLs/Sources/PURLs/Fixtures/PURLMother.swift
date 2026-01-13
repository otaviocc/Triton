#if DEBUG

    import Foundation
    import PURLsPersistenceService
    import SwiftData

    extension PURL {

        // MARK: - Public

        @MainActor
        static func makePURL(
            count: Int,
            in container: ModelContainer
        ) {
            for index in 0..<count {
                let purl = PURL(
                    name: "purl\(index)",
                    url: URL(string: "http://subdomain\(index).otavio.lol")!,
                    address: "otaviocc"
                )

                container.mainContext.insert(
                    purl
                )
            }
        }
    }

#endif
