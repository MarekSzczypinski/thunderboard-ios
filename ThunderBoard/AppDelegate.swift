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
    let notificationCenter = UNUserNotificationCenter.current()
    fileprivate var applicationPresenter: ApplicationPresenter?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        notificationCenter.delegate = self
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
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
}

// TODO: refactor to separate class... ?
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 1
    // called when a notification is delivered to a foreground app. You receive the UNNotification object which contains the original UNNotificationRequest.
    // You call the completion handler with the UNNotificationPresentationOptions you want to present (use .none to ignore the alert).
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(#function)
        log.info("notification=\(notification) userInfo=\(notification.request.content.userInfo)")
        handleLocalNotification(notification)
        completionHandler([.alert])
    }
    
    // 2
    // called when a user selects an action in a delivered notification. You receive the UNNotificationResponse object which includes the actionIdentifier for the user action and the UNNotification object.
    // The system defined identifiers UNNotificationDefaultActionIdentifier and UNNotificationDismissActionIdentifier are used when the user taps the notification to open the app or swipes to dismiss the notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(#function)
        log.info("identifier=\(response.actionIdentifier) notification=\(response.notification) userInfo=\(response.notification.request.content.userInfo)")
        handleLocalNotification(response.notification)
        completionHandler()
    }
    
    //MARK: - Private
    fileprivate func handleLocalNotification(_ notification: UNNotification) {
        log.info("notification=\(notification)")
        
        if let name = notification.request.content.userInfo["deviceName"] as? String {
            log.info("Attempting to start connection to \(name)")
            self.applicationPresenter?.connectToNearbyDevice(name)
        } else {
            log.info("Failed to start direct connection - device name not found in notification payload")
        }
    }
}
