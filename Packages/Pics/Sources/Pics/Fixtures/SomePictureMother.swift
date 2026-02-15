// MIT License
//
// Copyright (c) 2026 Otávio Cordeiro
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
            for index in 0..<count {
                SomePicture.makePicture(
                    created: Double(index * index),
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
