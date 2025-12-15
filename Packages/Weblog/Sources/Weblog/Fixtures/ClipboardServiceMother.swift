#if DEBUG

    import ClipboardService
    import Foundation

    enum ClipboardServiceMother {

        // MARK: - Nested types

        private final class FakeClipboardService: ClipboardServiceProtocol {

            func copy(_ string: String) {}
            func copy(_ data: Data, type: String) {}
        }

        // MARK: - Public

        static func makeClipboardService() -> ClipboardServiceProtocol {
            FakeClipboardService()
        }
    }

#endif
