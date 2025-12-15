#if os(iOS)

    import UIKit

    struct IOSClipboardService: ClipboardServiceProtocol {

        func copy(_ string: String) {
            UIPasteboard
                .general
                .string = string
        }

        func copy(
            _ data: Data,
            type: String
        ) {
            UIPasteboard
                .general
                .setData(
                    data,
                    forPasteboardType: type
                )
        }
    }

#endif
