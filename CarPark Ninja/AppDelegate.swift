//
//  AppDelegate.swift
//  CarPark Ninja
//
//  Created by Max Hooton on 14/07/2019.
//  Copyright © 2019 CarPark Ninja. All rights reserved.
//

import UIKit
import CoreData
import CarPlay

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CPApplicationDelegate, CPMapTemplateDelegate {
    
    // MARK: - CarPlay Reference variables
    var carWindow: CPWindow?
    var interfaceController: CPInterfaceController?
    var mapTemplate: CPMapTemplate?
    
    // MARK: - Needed to show initial storyboard
    var window: UIWindow?
    
    // MARK: - CPApplicationDelegate methods
    func application(_ application: UIApplication, didConnectCarInterfaceController interfaceController: CPInterfaceController, to window: CPWindow) {
        print("[CARPLAY] CONNECTED TO CARPLAY!")
        
        // Keep references to the CPInterfaceController (handles your templates) and the CPMapContentWindow (to draw/load your own ViewController's with a navigation map onto)
        self.interfaceController = interfaceController
        self.carWindow = window
        
        print("[CARPLAY] CREATING CPMapTemplate...")
        
        // Create a map template and set it as the root on the interfacecontroller (you may push/pop templates like a UINavigationController) Also assign delegate for the callbacks
        let mapTemplate = createTemplate()
        mapTemplate.mapDelegate = self
        
        self.mapTemplate = mapTemplate
        
        print("[CARPLAY] SETTING ROOT OBJECT OF INTERFACECONTROLLER TO MAP TEMPLATE...")
        interfaceController.setRootTemplate(mapTemplate, animated: true)
        
        print("[CARPLAY] SETTING CustomNavigationViewController as root VC...")
        window.rootViewController = CustomNavigationViewController()
        
        // Note: Obviously the AppDelegate is a bad place to handle everything and save all your references. This is done for example, don't put everything in the same class 🙃
    }
    
    func application(_ application: UIApplication, didDisconnectCarInterfaceController interfaceController: CPInterfaceController, from window: CPWindow) {
        print("[CARPLAY] DISCONNECTED FROM CARPLAY!")
    }
    
    func application(_ application: UIApplication, didSelect navigationAlert: CPNavigationAlert) {
        // TODO: Implementation
    }
    
    func application(_ application: UIApplication, didSelect maneuver: CPManeuver) {
        // TODO: Implementation
    }
    
    // MARK: - CPMapTemplate creation
    func createTemplate() -> CPMapTemplate {
        // Create the default CPMapTemplate objcet (you may subclass this at your leasure)
        let mapTemplate = CPMapTemplate()
        
        // Create the different CPBarButtons
        let searchBarButton = createBarButton(.search)
        mapTemplate.leadingNavigationBarButtons = [searchBarButton]
        
        let panningBarButton = createBarButton(.panning)
        mapTemplate.trailingNavigationBarButtons = [panningBarButton]
        
        // Always show the NavigationBar
        mapTemplate.automaticallyHidesNavigationBar = false
        
        return mapTemplate
    }
    
    // MARK: - CPMapTemplate delegate method
    func mapTemplateWillDismissPanningInterface(_ mapTemplate: CPMapTemplate) {
        mapTemplate.trailingNavigationBarButtons = [createBarButton(.panning)]
    }
    
    // MARK: - CPBarButton creation
    enum BarButtonType: String {
        case search = "Search"
        case panning = "Pan map"
        case dismiss = "Dismiss"
    }
    
    private func createBarButton(_ type: BarButtonType) -> CPBarButton {
        let barButton = CPBarButton(type: .text) { (button) in
            print("[CARPLAY] SEARCH MAP TEMPLATE \(button.title ?? "-") TAPPED")
            
            switch(type) {
            case .dismiss:
                // Dismiss the map panning interface
                self.mapTemplate?.dismissPanningInterface(animated: true)
            case .panning:
                // Enable the map panning interface and set the dismiss button
                self.mapTemplate?.showPanningInterface(animated: true)
                self.mapTemplate?.trailingNavigationBarButtons = [self.createBarButton(.dismiss)]
            default:
                break
            }
        }
        
        // Set title based on type
        barButton.title = type.rawValue
        
        return barButton
    }
    
    // MARK: - Unimplemented UIApplicationDelegate delegate methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CarPark_Ninja")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
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
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

