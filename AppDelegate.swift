//
// Copyright (c) WhatsApp Inc. and its affiliates.
// All rights reserved.
//
// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//

import UIKit
import CoreData
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Inicialize o Google Mobile Ads
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // Crie uma instância do HomePageViewController
        let controller = HomePageViewController()
        let navigation = UINavigationController(rootViewController: controller)
        
        // Crie uma UIWindow e defina o HomePageViewController como a raiz
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        
        return true
    }

    
    // MARK: - Core Data stack
       lazy var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "StoredImage")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
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
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }
}
