//
//  AppDelegate.swift
//  Zupet
//
//  Created by Pankaj Rawat on 21/07/25.
//

import UIKit
import GoogleSignIn
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Keyboard handling (no toolbar)
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistance = 10
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = true // no warning, still valid
        
        // Toolbar handling (new manager)
        let toolbarManager = IQKeyboardToolbarManager.shared
        toolbarManager.isEnabled = true
        toolbarManager.playInputClicks = false  // ✅ no deprecation warning

        KeyboardGlobalManager.shared.start()
        
        Task { [weak self] in
            guard self != nil else { return }
            await APIManager.initializeShared()
            Log.debug("ApiManager is Ready")
        }
        
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path),
           let apiKey = dict["GOOGLE_MAPS_API_KEY"] as? String {
            GMSServices.provideAPIKey(apiKey)
            GMSPlacesClient.provideAPIKey(apiKey)
        }

        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}
