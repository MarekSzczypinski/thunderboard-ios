//
//  NotificationSettingsInteraction.swift
//  Thunderboard
//
//  Copyright © 2016 Silicon Labs. All rights reserved.
//

import UIKit

let UserNotificationSettingsUpdatedEvent = "com.silabs.notificationsettings"

protocol NotificationSettingsInteractionOutput : class {
    func notificationsEnabled(_ enabled: Bool)
    func notificationDevicesUpdated()

    func locationServicesNotAllowed()
    func notificationsNotAllowed()
}

class NotificationSettingsInteraction : NotificationManagerDelegate {
    
    weak var manager: NotificationManager? {
        didSet {
            manager?.delegate = self
            notifyUpdates()
        }
    }
    
    weak var output: NotificationSettingsInteractionOutput? {
        didSet {
            notifyUpdates()
        }
    }

    init() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: UserNotificationSettingsUpdatedEvent), object: nil, queue: nil) { [weak self] (notification: Notification) -> Void in
            self?.notificationSettingsUpdated()
        }
    }
    
    func enableNotifications(_ enabled: Bool) {
        // During testing, this may be a desired behavior
        // if enabled == false {
        //     removeAllDevices()
        // }

        self.manager?.enableNotifications(enabled)
    }
    
    func allowDevice(_ index: Int) {
        self.manager?.allowDevice(otherDevices()[index])
        notifyUpdates()
    }
    
    func removeDevice(_ index: Int) {
        self.manager?.removeDevice(allowedDevices()[index])
        notifyUpdates()
    }
    
    func allowedDevices() -> [NotificationDevice] {
        guard let devices = self.manager?.allowedDevices() else {
            return []
        }
        
        return devices.map({
            return self.displayDevice($0)
        })
    }
    
    func otherDevices() -> [NotificationDevice] {
        guard let devices = self.manager?.otherDevices() else {
            return []
        }
        
        return devices.map({
            return self.displayDevice($0)
        })
    }
   
    //MARK: - NotificationManagerDelegate
    
    func notificationsEnabled(_ enabled: Bool) {
        notifyUpdates()
        
        if enabled {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] (didAllow, error) in
                if let requestAuthorizationError = error {
                    print("Error when requesting authorization: \(requestAuthorizationError.localizedDescription)")
                    return
                }
                if didAllow {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: UserNotificationSettingsUpdatedEvent), object: nil)
                } else {
                    self?.notificationsNotAllowed()
                }
            }
        }
    }
    
    func locationServicesNotAllowed() {
        self.manager?.enableNotifications(false)
        output?.locationServicesNotAllowed()
    }
    
    func notificationsNotAllowed() {
        self.manager?.enableNotifications(false)
        output?.notificationsNotAllowed()
    }
    
    //MARK: - Private
    
    fileprivate func notificationSettingsUpdated() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] (notificationSettings) in
            if notificationSettings.authorizationStatus != .authorized {
                self?.notificationsNotAllowed()
            }
        }
    }
    
    fileprivate func notifyUpdates() {
        if let enabled = self.manager?.notificationsEnabled {
            output?.notificationsEnabled(enabled)
            output?.notificationDevicesUpdated()
        }
    }
    
    fileprivate func removeAllDevices() {
        self.manager?.removeAllDevices()
    }
    
    fileprivate func displayDevice(_ notificationDevice: NotificationDevice) -> NotificationDevice {
        return notificationDevice
    }
}
