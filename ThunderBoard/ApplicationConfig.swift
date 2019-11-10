//
//  UIApplication+EnvironmentConfiguration.swift
//  Thunderboard
//
//  Copyright © 2016 Silicon Labs. All rights reserved.
//

import UIKit

class ApplicationConfig {
    
    // URL used for microsite links (sent in demo emails)
    class var ProductMicroSiteUrl: String {
        get { return "https://www.silabs.com/thunderboard" }
    }
    
    // Firebase web app host ("your-application-0001.firebaseapp.com")
    class var FirebaseDemoHost: String {
        get { return "" }
    }
    
// Uncomment to use AppCenter
//    AppCenter Token - (Character string provided by App Center for crash reporting)
//    class var AppCenterToken: String? {
//        get { return nil }
//    }
}
