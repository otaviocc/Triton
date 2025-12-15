#if DEBUG

    import Foundation
    import PicsPersistenceService
    import SwiftData

    extension SomePicture {

        // MARK: - Public

        @MainActor
        static func makePictures(
            count: Int = 3,
            in container: ModelContainer
        ) {
            for i in 0..<count {
                SomePicture.makePicture(
                    created: Double(i * i),
                    in: container
                )
            }
        }

        @MainActor
        static func makePicture(
            created: Double = 1_700_000_000,
            in container: ModelContainer
        ) {
            let picture = SomePicture(
                id: UUID().uuidString,
                address: "otaviocc",
                created: created,
                mime: "jpeg",
                size: 123_456,
                url: "https://cdn.some.pics/otaviocc/68c94c4c8d334.jpg",
                somePicsURL: "https://otaviocc.some.pics/68c94c4c8d334",
                caption: "Public bus interior with passengers, yellow pole, and wheelchair sign.",
                alt: "The image shows the interior of a public bus. Several passengers are seated, facing forward. A yellow pole with a green STOP button is visible in the foreground. There is a sign indicating a space reserved for wheelchair users on the right. Through the bus windows, a street scene with a pedestrian and buildings can be seen in the background. The bus is equipped with yellow handrails and black seats.",
                tags: ["tag1", "tag2"]
            )

            container.mainContext.insert(
                picture
            )
        }
    }

#endif
