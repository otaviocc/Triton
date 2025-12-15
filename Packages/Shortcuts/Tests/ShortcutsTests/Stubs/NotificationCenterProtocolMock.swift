import Foundation
@testable import Shortcuts

final class NotificationCenterProtocolMock: NotificationCenterProtocol, @unchecked Sendable {

    private let lock = NSLock()
    private var _postedNotifications: [(
        name: NSNotification.Name,
        object: Any?,
        userInfo: [AnyHashable: Any]?
    )] = []

    var postedNotifications: [(
        name: NSNotification.Name,
        object: Any?,
        userInfo: [AnyHashable: Any]?
    )] {
        lock.lock()
        defer { lock.unlock() }
        return _postedNotifications
    }

    func post(
        name: NSNotification.Name,
        object: Any?,
        userInfo: [AnyHashable: Any]?
    ) {
        lock.lock()
        defer { lock.unlock() }
        _postedNotifications.append((name, object, userInfo))
    }

    func addObserver(
        forName name: NSNotification.Name?,
        object: Any?,
        queue: OperationQueue?,
        using block: @escaping @Sendable (Notification) -> Void
    ) -> NSObjectProtocol {
        NSObject()
    }
}
