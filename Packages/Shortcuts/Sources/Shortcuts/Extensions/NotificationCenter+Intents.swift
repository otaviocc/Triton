import Foundation

protocol NotificationCenterProtocol: Sendable {

    func post(
        name: NSNotification.Name,
        object: Any?,
        userInfo: [AnyHashable: Any]?
    )

    @discardableResult
    func addObserver(
        forName name: NSNotification.Name?,
        object: Any?,
        queue: OperationQueue?,
        using block: @escaping @Sendable (Notification) -> Void
    ) -> NSObjectProtocol
}

extension NotificationCenter: NotificationCenterProtocol {}
