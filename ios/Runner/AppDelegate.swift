import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GMSServices.provideAPIKey("AIzaSyAQk0BDUcdmln3zCV4CbPDn7UF2Y1PjD7Q")
        FirebaseApp.configure()
        
        // ✅ Set FCM delegate
        Messaging.messaging().delegate = self
        
        GeneratedPluginRegistrant.register(with: self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // ✅ FCM Token (optional debug)
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Token: \(fcmToken ?? "")")
    }
}