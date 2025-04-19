import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      // Prevent screenshots and screen recording
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(enableScreenCapture),
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )

        // Initially disable screen capture
        disableScreenCapture()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
   @objc func enableScreenCapture() {
        // Re-enable screen capture if the app is not in the foreground
        if !UIScreen.main.isCaptured {
            disableScreenCapture()
        }
    }

    func disableScreenCapture() {
        // Add a secure view to prevent screenshots and screen recording
        let secureView = UIView()
        secureView.backgroundColor = .black
        secureView.frame = UIScreen.main.bounds
        secureView.isUserInteractionEnabled = false
        self.window?.addSubview(secureView)
        self.window?.layer.superlayer?.addSublayer(secureView.layer)
    }
}
