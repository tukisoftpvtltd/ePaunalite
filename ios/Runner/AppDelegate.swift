// import UIKit
// import Flutter
// import FirebaseCore


// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     FirebaseApp.configure()
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }


import UIKit
import Flutter
import FirebaseCore
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()

        GeneratedPluginRegistrant.register(with: self)

        // Add this line to handle background notifications
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // This method will be called when a notification is received while the app is in the foreground
    @available(iOS 10.0, *)
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.alert, .sound, .badge])
    }

    // This method will be called when a notification is tapped
    @available(iOS 10.0, *)
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            // Handle notification tap
            print("Notification tapped")

            // You can add your logic here to open the relevant screen or perform an action
            // For example, you can use Flutter method channels to communicate with Dart code

            // Example: Sending a message back to Dart
            let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
            let channel = FlutterMethodChannel(name: "notification", binaryMessenger: controller.binaryMessenger)
            channel.invokeMethod("handleNotificationTap", arguments: nil)
        }

        completionHandler()
    }
}
