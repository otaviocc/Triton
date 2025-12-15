#if os(macOS)

    import AppKit

    struct MacOSClipboardService: ClipboardServiceProtocol {

        func copy(_ string: String) {
            NSPasteboard
                .general
                .clearContents()

            NSPasteboard
                .general
                .setString(
                    string,
                    forType: .string
                )
        }

        func copy(_ data: Data, type: String) {
            NSPasteboard
                .general
                .clearContents()

            NSPasteboard
                .general
                .setData(
                    data,
                    forType: NSPasteboard.PasteboardType(type)
                )
        }
    }

#endif
