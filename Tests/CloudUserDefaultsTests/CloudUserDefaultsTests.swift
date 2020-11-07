import XCTest
@testable import CloudUserDefaults

final class CloudUserDefaultsTests: XCTestCase {

    private let prefix = "cloud_"
    private let testKey = "test_key"
    private let testCloudKey = "cloud_test_key"
    private let testValue = "MugunthKumar"
    private let unusedNotification = NSNotification(name: NSNotification.Name(""), object: nil)

    override func setUpWithError() throws {
        UserDefaults.standard.removeObject(forKey: testKey)
        UserDefaults.standard.removeObject(forKey: testCloudKey)
    }

    func testStart() {
        let cloudUserDefaults = CloudUserDefaults()
        cloudUserDefaults.start(prefix: prefix)
        XCTAssertEqual(cloudUserDefaults.prefix, prefix)
    }

    func testNotificationFromCloud() {
        let cloudUserDefaults = CloudUserDefaults()
        cloudUserDefaults.start(prefix: prefix)

        //  Check that CloudUserDefaults.cloudSyncNotification is sent
        let _ = expectation(forNotification: CloudUserDefaults.cloudSyncNotification, object: nil, handler: nil)
        cloudUserDefaults.notificationFromCloud(notification: unusedNotification)
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testNotifyCloud() {
        let cloudUserDefaults = CloudUserDefaults()
        cloudUserDefaults.start(prefix: prefix)
        UserDefaults.standard.set(testValue, forKey: testKey)
        UserDefaults.standard.set(testValue, forKey: testCloudKey)

        //  Check that values are set in expected stores
        XCTAssertNil(NSUbiquitousKeyValueStore.default.object(forKey: testKey))
        XCTAssertNotNil(UserDefaults.standard.object(forKey: testKey))
        XCTAssertNotNil(NSUbiquitousKeyValueStore.default.object(forKey: testCloudKey))
        XCTAssertNotNil(UserDefaults.standard.object(forKey: testCloudKey))
    }

    static var allTests = [
        ("testStart", testStart),
        ("testNotificationFromCloud", testNotificationFromCloud),
        ("testNotifyCloud", testNotifyCloud)
    ]
}
