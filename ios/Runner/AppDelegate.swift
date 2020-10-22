import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self) 
    GMSServices.provideAPIKey("AIzaSyAs4k7r81L8a_kk51E_piDGxHjkNS-EVp0")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
    
  }
}
