//
//  LGTv2App.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/22/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      return true
  }
}

@main
struct LGTv2App: App {

    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @State private var mapTabViewModel = MapTabViewModel()
    @State private var listTabViewModel = ListTabViewModel()
    @State private var searchTabViewModel = SearchTabViewModel()
    
      var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(mapTabViewModel)
                .environment(listTabViewModel)
                .environment(searchTabViewModel)
        }
      }
    }
