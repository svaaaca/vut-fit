//
// @file cookbook.swift
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief Entry point into the application.
// @date 2024-05-26
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct Cookbook: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // State object for app shared data
    @StateObject private var sharedData = Shared()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                Navigation()
            }
            // Set shared data as an environment object
            .environmentObject(sharedData)
        }
    }
}
