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

    import WeblogNetworkService

    enum EntryResponseMother {

        // MARK: - Public

        static func makeEntryResponse(
            id: String = "test-entry-id",
            location: String = "test-entry",
            date: Double = 1_700_000_000,
            status: String = "published",
            title: String = "Test Entry Title",
            body: String = "Test entry content goes here.",
            address: String = "otaviocc"
        ) -> EntryResponse {
            EntryResponse(
                id: id,
                location: location,
                date: date,
                status: status,
                title: title,
                body: body,
                address: address
            )
        }

        static func makeEntryResponses(count: Int = 5) -> [EntryResponse] {
            (0..<count).map { index in
                makeEntryResponse(
                    id: "entry-\(index)",
                    location: "test-entry-\(index)",
                    date: Double(1_700_000_000 + (index * 86400)),
                    status: index % 3 == 0 ? "draft" : "published",
                    title: "Test Entry \(index)",
                    body: "Content for test entry \(index)"
                )
            }
        }
    }

#endif
