//
//  AppDelegate.swift
//  Thunderboard
//
//  Copyright © 2016 Silicon Labs. All rights reserved.
//

import UIKit
//import HockeySDK
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //let notificationCenter = UNUserNotificationCenter.current()
    fileprivate var applicationPresenter: ApplicationPresenter?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
//        notificationCenter.delegate = self
//        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
//        // 3
//        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
//            if !didAllow {
//                print("User has declined notifications")
//            } else {
//            }
//        }
        
//        if let hockeyToken = ApplicationConfig.HockeyToken {
//            BITHockeyManager.shared().configure(withIdentifier: hockeyToken)
//            BITHockeyManager.shared().start()
//        }

        let background = application.applicationState
        log.info("launchOptions=\(String(describing: launchOptions)) background=\(background.rawValue)")

        FirebaseConnectionMonitor.shared.checkAuth()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.tintColor = StyleColor.terbiumGreen
        self.applicationPresenter = ApplicationPresenter(window: self.window)
        self.applicationPresenter?.showDeviceSelection()
        self.window?.makeKeyAndVisible()

        return true
    }
    
    // 1
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        log.info("notification=\(notification) userInfo=\(String(describing: notification.userInfo))")
        handleLocalNotification(notification)
    }
    
    // 2
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        log.info("identifier=\(String(describing: identifier)) notification=\(notification) userInfo=\(String(describing: notification.userInfo))")
        handleLocalNotification(notification)
        completionHandler()
    }
    
    // 3
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        log.debug("notificationSettings: \(notificationSettings)")
        NotificationCenter.default.post(name: Notification.Name(rawValue: UserNotificationSettingsUpdatedEvent), object: nil)
    }
    
    //MARK: - Private
    
    fileprivate func handleLocalNotification(_ notification: UILocalNotification) {
        log.info("notification=\(notification)")
        
        if let name = notification.userInfo?["deviceName"] as? String {
            log.info("Attempting to start connection to \(name)")
            self.applicationPresenter?.connectToNearbyDevice(name)
        }
        else {
            log.info("Failed to start direct connection - device name not found in notification payload")
        }
    }
}

//extension AppDelegate: UNUserNotificationCenterDelegate {
//    
//    // 1
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//    }
//    
//    // 2
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//    }
//    
//}
