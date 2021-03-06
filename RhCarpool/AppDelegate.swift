//
//  AppDelegate.swift
//  RhCarpool
//
//  Created by Ravi on 16/04/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var handle: AuthStateDidChangeListenerHandle?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch. 
        FirebaseApp.configure()
        Thread.sleep(forTimeInterval: 1.0)
            let isAuthenticatedUser = self.userAuthentication()
            if !isAuthenticatedUser {
                let loginVC = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewController(withIdentifier: "login")
                let navigationController = UINavigationController.init(rootViewController: loginVC)
                self.window?.rootViewController = navigationController
            } else {
               let homeVC = UIStoryboard(name: "Main", bundle: nil)
                                                .instantiateViewController(withIdentifier: "home")
                let navigationController = UINavigationController.init(rootViewController: homeVC)
                self.window?.rootViewController = navigationController
            }

        registerForGoogleMapsSdk()  //Google Maps
        return true
    }

    func userAuthentication() -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else {
            return false
        }
        let user = UserDefaults.getUserData()
        if user?.uidString == uid {
            if user?.authToken != .none {
                FireBaseDataBase.sharedInstance.getUserData(uid: uid)
                return true
            }
        }
        return false
  }

    // MARK: Google Maps SDK
    func registerForGoogleMapsSdk() {
        GMSServices.provideAPIKey(RhConstants.gmsAPIKey)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "RhCarpool")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                //You should not use this function in a shipping application, 
                //although it may be useful during development.
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or 
                 data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. 
                //You should not use this function in a shipping application, 
                //although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
