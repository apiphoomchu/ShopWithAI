//
//  ShopWithAIApp.swift
//  ShopWithAI
//
//  Created by Apiphoom Chuenchompoo on 26/10/2567 BE.
//

import SwiftUI
import FirebaseCore
import FirebaseVertexAI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}


@main
struct ShopWithAIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
