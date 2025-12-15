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
            for i in 0..<count {
                let purl = PURL(
                    name: "purl\(i)",
                    url: URL(string: "http://subdomain\(i).otavio.lol")!,
                    address: "otaviocc"
                )

                container.mainContext.insert(
                    purl
                )
            }
        }
    }

#endif
