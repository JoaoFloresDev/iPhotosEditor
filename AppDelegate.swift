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
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        //        select root
        if (UserDefaults.standard.object(forKey: "FirtsUse") == nil) {
            self.window = UIWindow(frame: UIScreen.main.bounds)

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginSignupVC")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }


        print("oi")

//        var pi = Float.pi
//        var mI = Float(2.87/10000000)
//        var contant513 = pow(Float(5),Float(3/2))
//        var R = Float(0.105833)
//        var n = 140
//        var miZero = Float(4*pi/10000000)
//        var miAPos = Float(0.38)
//        var miANeg = Float(0.4)
//        var miR = Float(0.00002)
//        var miMi = Float(0.00000011)
//        var azinho = Float(17.43)
//
//        var cima = pow((pow(pi,2) * mI * contant513 * R), 2)
//        var baixo = pow(2 * miZero * 140, 2)
//        var final1 = (cima / baixo) * pow(miAPos,2)
//
//        cima = pow((pow(pi,2) * mI * contant513 * azinho), 2)
//        baixo = pow(2 * miZero * 140, 2)
//        var final2 = (cima / baixo) * pow(miR,2)
//
//        cima = pow((pow(pi,2) * contant513 * azinho * R), 2)
//        baixo = pow(2 * miZero * 140, 2)
//        var final3 = (cima / baixo) * pow(miMi,2)
//
//        print("--------")
//        var final = sqrt(final1 + final2 + final3)
//        print(final)
//        print("--------")
//

//        var pi = Float.pi
//        var mI = Float(2.87/10000000)
//        var contant513 = pow(Float(5),Float(3/2))
//        var R = Float(0.105833)
//        var n = 140
//        var miZero = Float(4*pi/10000000)
//        var miAPos = Float(0.38)
//        var miANeg = Float(0.4)
//        var miR = Float(0.00002)
//        var miMi = Float(0.00000011)
//        var azinho = Float(17.43)
//
//        var cima = pow((pow(pi,2) * mI * contant513 * R), 2)
//        var baixo = pow(2 * miZero * 140, 2)
//        var final1 = (cima / baixo) * pow(miAPos,2)
//
//        cima = pow((pow(pi,2) * mI * contant513 * azinho), 2)
//        baixo = pow(2 * miZero * 140, 2)
//        var final2 = (cima / baixo) * pow(miR,2)
//
//        cima = pow((pow(pi,2) * contant513 * azinho * R), 2)
//        baixo = pow(2 * miZero * 140, 2)
//        var final3 = (cima / baixo) * pow(miMi,2)
//
//        print("--------")
//        var final = sqrt(final1 + final2 + final3)
//        print(final)
//        print("--------")

        var pi = Float.pi
        var mi = Float(0.17)
        var miMi = Float(0.00000011)
        var bzinho = Float(0.32)
        var cima = pow((pow(pi,2) * 4 * bzinho), 2)
        var baixo = pow(mi, 2)
        var final1 = (cima / baixo) * pow(0.00000011,2)

        cima = pow((pow(pi,2) * -4 * bzinho * 2.87 / 10000000), 2)
        baixo = pow(mi, 4)
        var final2 = (cima / baixo) * pow(0.03,2)

        cima = pow((pow(pi,2) * 4 * 2.87 / 10000000), 2)
        baixo = pow(mi, 2)
        var final3 = (cima / baixo) * pow(0.06,2)

        print("--------")
        var final = sqrt(final1 + final2 + final3)
        print(final)
        print("--------")


        
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
