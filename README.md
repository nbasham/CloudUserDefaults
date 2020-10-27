# About

CloudUserDefaults automatically syncs `UserDefaults` **values** that use a **key** with a specified prefix to the cloud. Behind the scenes it listens to system events and when a `UserDefaults` **key** with the given prefix is set all the user's devices are automatically synced with the new value. For example, if you choose ***cloud_*** as the prefix `UserDefaults.standard.set(1, forKey: "cloud_count")` is set on all the user's devices.

This is based on Mugunth Kumar's elegant solution `MKiCloudSync` an Objective-C [GitHub repository](https://github.com/MugunthKumar/MKiCloudSync) that is now archived. Thanks to Paul Hudson for suggesting `MKiCloudSync`.

## Installation

### Swift Package Manager
If you are using Xcode 11 or later:
 1. Click `File`
 2. `Swift Packages`
 3. `Add Package Dependency...`
 4. Specify the git URL for CloudUserDefaults.

```swift
https://github.com/nbasham/CloudUserDefaults.git
```

### Manual
Copy `CloudUserDefaults.swift` to your project

## Setup
In Xcode, select your project, select your target, click `Signing & Capabilities`, click `+ Capability`, select iCloud. Check the `Key-value storage` checkbox.

**NOTE** iCloud events are not sent to the simulator.

## Usage
Create an instance of `CloudUserDefaults` some place it will stay in scope (e.g. in your `AppDelegate`) and call `start` with a prefix of your choosing e.g.
```swift
import CloudUserDefaults
...
let cloudUserDefaults = CloudUserDefaults()
cloudUserDefaults.start(prefix: "cloud_")
```
Whenever a `UserDefaults` **key** starts with `cloud_` it is automatically synced to all the user's devices e.g.
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
## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)


