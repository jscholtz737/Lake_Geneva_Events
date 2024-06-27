//
//  LGTv2App.swift
//  LGTv2
//
//  Created by Joseph Scholtz on 6/22/24.
//

import SwiftUI
import FirebaseCore
import Firebase
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
      //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        FirebaseApp.configure()
        let db = Firestore.firestore()
        let events = db.collection("events")
        let document = events.document("Pq4HkmIp45Q5A5yLezxu")
        document.getDocument { docSnapshot, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let docSnapshot = docSnapshot {
                print(docSnapshot.data() ?? "nil")
            } else {
                //no data returned
            }
            
        }
    }
        
      var body: some Scene {
        WindowGroup {
          NavigationView {
            ContentView()
          }
        }
      }
    }
