import Foundation

open class CloudUserDefaults {

    public static let cloudSyncNotification = Notification.Name("CloudSyncNotification")
    internal var prefix: String!

    public init() {}

    public func start(prefix: String) {
        self.prefix = prefix
        NotificationCenter.default.addObserver(self, selector: #selector(notificationFromCloud(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyCloud(notification:)), name: UserDefaults.didChangeNotification, object: nil)
    }

    @objc internal func notificationFromCloud(notification: NSNotification) {
        let dict = NSUbiquitousKeyValueStore.default.dictionaryRepresentation

        //  Disable notifications to cloud while we set local values from cloud
        NotificationCenter.default.removeObserver(self, name: UserDefaults.didChangeNotification, object: nil)

        for (key, value) in dict {
            if key.hasPrefix(prefix) {
                UserDefaults.standard.set(value, forKey: key)
            }
        }

        //  Resume notifications to cloud
        NotificationCenter.default.addObserver(self, selector: #selector(notifyCloud(notification:)), name: UserDefaults.didChangeNotification, object: nil)

        //  Send a message with cloud payload that app can listen to
        NotificationCenter.default.post(name: CloudUserDefaults.cloudSyncNotification, object: dict)
    }

    @objc internal func notifyCloud(notification: NSNotification) {
        let dict = UserDefaults.standard.dictionaryRepresentation()
        for (key, value) in dict {
            if key.hasPrefix(prefix) {
                NSUbiquitousKeyValueStore.default.set(value, forKey: key)
            }
        }
    }
}
