//
//  AppDelegate.swift
//  MovingCells
//
//  Created by Ozgur Vatansever on 4/24/16.
//  Copyright © 2016 Ozgur Vatansever. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window?.rootViewController = UINavigationController(rootViewController: CollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()))
    window?.makeKeyAndVisible()
    
    return true
  }
}
