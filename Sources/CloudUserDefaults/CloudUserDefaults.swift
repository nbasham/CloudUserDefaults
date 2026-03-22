import Foundation

/// Automatically syncs `UserDefaults` values to iCloud across all of a user's devices.
/// Values are synced when their key matches a specified prefix.
///
/// Create an instance somewhere it will stay in scope, then call ``start(prefix:)``.
///
/// ```swift
/// // AppDelegate
/// let cloudUserDefaults = CloudUserDefaults()
/// cloudUserDefaults.start(prefix: "cloud_")
/// ```
open class CloudUserDefaults {

    /// Posted when values have been received from iCloud.
    /// The notification object contains the full iCloud key-value dictionary.
    public static let cloudSyncNotification = Notification.Name("CloudSyncNotification")

    internal var prefix: String!
    private let defaults: UserDefaults

    /// Creates a new instance using the specified `UserDefaults` store.
    /// - Parameter defaults: The `UserDefaults` instance to sync. Defaults to `UserDefaults.standard`.
    ///   Pass a suite-based instance for app groups and widgets.
    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    /// Begins listening for changes to `UserDefaults` and iCloud, syncing any key that starts with the given prefix.
    /// - Parameter prefix: The key prefix that identifies values to sync, e.g. `"cloud_"`.
    public func start(prefix: String) {
        self.prefix = prefix
        NotificationCenter.default.addObserver(self, selector: #selector(notificationFromCloud(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyCloud(notification:)), name: UserDefaults.didChangeNotification, object: defaults)
    }

    @objc internal func notificationFromCloud(notification: NSNotification) {
        let dict = NSUbiquitousKeyValueStore.default.dictionaryRepresentation
        //  Disable notifications to cloud while we set local values from cloud
        NotificationCenter.default.removeObserver(self, name: UserDefaults.didChangeNotification, object: defaults)
        for (key, value) in dict {
            if key.hasPrefix(prefix) {
                defaults.set(value, forKey: key)
            }
        }
        //  Resume notifications to cloud
        NotificationCenter.default.addObserver(self, selector: #selector(notifyCloud(notification:)), name: UserDefaults.didChangeNotification, object: defaults)
        //  Send a message with cloud payload that app can listen to
        NotificationCenter.default.post(name: CloudUserDefaults.cloudSyncNotification, object: dict)
    }

    @objc internal func notifyCloud(notification: NSNotification) {
        let dict = defaults.dictionaryRepresentation()
        for (key, value) in dict {
            if key.hasPrefix(prefix) {
                NSUbiquitousKeyValueStore.default.set(value, forKey: key)
            }
        }
    }
}
