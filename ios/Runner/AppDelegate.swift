import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Ключ обязательно должен быть ПЕРЕД GeneratedPluginRegistrant
    GMSServices.provideAPIKey("AIzaSyAri8BUgkt8jIVDo6gRxjkMDtXg4xiGntc")
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}