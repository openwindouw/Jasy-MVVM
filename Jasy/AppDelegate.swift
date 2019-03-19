//
//  AppDelegate.swift
//  Jasy
//
//  Created by Vladimir Espinola on 9/13/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationBarAppearance.tintColor = .white
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.shadowImage = UIImage()
        
        //UIButtonBarButton
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).title = "Cancel"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel"
        
        let searchBarTextField = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        searchBarTextField.tintColor = .white
        searchBarTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ])
        
        UITextField.appearance().tintColor = .black
        
        return true
    }
}

