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
      let db = Firestore.firestore()
      let events = db.collection("events")
      events.getDocuments { querySnapshot, error in
          if let error = error {
              print(error.localizedDescription)
          } else if let querySnapshot = querySnapshot {
              for doc in querySnapshot.documents {
                  print(doc.data())
              }
          } else {
              //no data returned
          }
      }
     
      return true
  }
}

@main
struct LGTv2App: App {
    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
 
      var body: some Scene {
        WindowGroup {
          NavigationView {
            ContentView()
          }
        }
      }
    }
