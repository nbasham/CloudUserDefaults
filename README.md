# About
Just drop one file in your project and add a few lines of code and your settings are now visible to all your user's devices.

CloudUserDefaults automatically syncs `UserDefaults` **values** that use a **key** with a specified prefix to the cloud. Silently listening to system events it detects when a `UserDefaults` **key** with a given prefix is changed and automatically syncs the **value**. For example, if you choose ***cloud_*** as the prefix `UserDefaults.standard.set(1, forKey: "cloud_count")` is set on all the user's devices.

This is based on Mugunth Kumar's elegant solution `MKiCloudSync` an Objective-C [GitHub repository](https://github.com/MugunthKumar/MKiCloudSync) that is now archived. Thanks to [Paul Hudson for the introduction to `MKiCloudSync`](https://www.hackingwithswift.com/example-code/system/how-to-store-userdefaults-options-in-icloud).

![CI](https://github.com/nbasham/CloudUserDefaults/actions/workflows/ci.yml/badge.svg)

## Installation
### Swift Package Manager
 1. Click `File`
 2. `Add Package Dependencies...`
 3. Specify the git URL for CloudUserDefaults.
```swift
https://github.com/nbasham/CloudUserDefaults.git
```
### Manual
Copy `CloudUserDefaults.swift` to your project

## Setup
In Xcode, click your project, click your target, click `Signing & Capabilities`, click `+ Capability`, select iCloud. Check the `Key-value storage` checkbox.

**NOTE** iCloud events are not sent to the simulator.

## Usage
Create an instance of `CloudUserDefaults` somewhere it will stay in scope and call `start` with a prefix of your choosing.

**AppDelegate**
```swift
import CloudUserDefaults
...
let cloudUserDefaults = CloudUserDefaults()
cloudUserDefaults.start(prefix: "cloud_")
```

**SwiftUI**
```swift
import CloudUserDefaults

@main
struct MyApp: App {
    let cloudUserDefaults = CloudUserDefaults()

    init() {
        cloudUserDefaults.start(prefix: "cloud_")
    }
}
```

That's it, whenever a `UserDefaults` **key** starts with `cloud_` it is automatically synced to all the user's devices e.g.
```swift
UserDefaults.standard.set(42, forKey: "cloud_answer") // synced to cloud
UserDefaults.standard.set(42, forKey: "answer")       // local
```

Subscribe to `CloudUserDefaults.cloudSyncNotification` if you want to be notified when user defaults from another device are delivered e.g.
```swift
NotificationCenter.default.addObserver(self,
    selector: #selector(cloudUpdate(notification:)),
    name: CloudUserDefaults.cloudSyncNotification,
    object: nil)
```

## Advanced Usage
If you use app groups (e.g. to share defaults with a widget), pass your suite instead:
```swift
let suite = UserDefaults(suiteName: "group.com.mycompany.myapp")!
let cloudUserDefaults = CloudUserDefaults(defaults: suite)
cloudUserDefaults.start(prefix: "cloud_")
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
