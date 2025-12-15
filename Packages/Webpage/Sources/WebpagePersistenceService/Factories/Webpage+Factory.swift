extension Webpage {

    static func makeWebpage(
        storableWebpage: StorableWebpage
    ) -> Webpage {
        .init(
            address: storableWebpage.address,
            markdown: storableWebpage.markdownContent,
            timestamp: storableWebpage.timestamp
        )
    }
}
