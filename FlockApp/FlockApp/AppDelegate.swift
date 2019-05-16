//
//  AppDelegate.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/5/19.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleMaps
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    static var authservice = AuthService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        splashScreen()
        // Override point for customization after application launch.
//        GMSServices.provideAPIKey(SecretKeys.googleKey)
//        FirebaseApp.configure()
//        UNUserNotificationCenter.current().delegate = self
//
//        // force signout
//        //try? Auth.auth().signOut()
//
//
//        window = UIWindow(frame: UIScreen.main.bounds)
//        if let _ = AppDelegate.authservice.getCurrentUser() {
//            window?.rootViewController = TabBarController()
//            //UITabBar.appearance().backgroundColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
//            //UITabBar.appearance().tintColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
//            UITabBar.appearance().unselectedItemTintColor = UIColor.darkGray
//           //. UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
//            UITabBar.appearance().unselectedItemTintColor = UIColor.darkGray
//            UINavigationBar.appearance().backgroundColor = UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1)
//            UINavigationBar.appearance().barTintColor = UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1)
//            UINavigationBar.appearance().largeTitleTextAttributes  = [NSAttributedString.Key.foregroundColor: UIColor.white]
//
////            UITabBar.appearance().unselectedItemTintColor = UIColor.darkGray
//
////            window?.makeKeyAndVisible()
//        } else {
//            let storyboard = UIStoryboard(name: "LoginView", bundle: nil)
//            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            window?.rootViewController = UINavigationController(rootViewController: loginViewController)
//        }
//        UINavigationBar.appearance().backgroundColor = UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1)
//        UINavigationBar.appearance().barTintColor = UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1)
//        UINavigationBar.appearance().tintColor = UIColor.white
//        UINavigationBar.appearance().prefersLargeTitles = true
//        UINavigationBar.appearance().largeTitleTextAttributes  = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        window?.makeKeyAndVisible()
//
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
//            if let error = error {
//                print("Request Authorization Error: \(error)")
//            } else if granted{
//                print("Authorization Granted")
//            } else{
//                print("User Denied")
//            }
//        }
//        self.window!.tintColor = #colorLiteral(red: 0.5921568627, green: 0.02352941176, blue: 0.737254902, alpha: 1)
        return true
    }
    private func splashScreen() {
//        window?.rootViewController = MainInterface()

        let launchScreenVC = MainInterface()
        window?.rootViewController = launchScreenVC
        window?.makeKeyAndVisible()
        Timer.scheduledTimer(timeInterval: 12, target: self, selector: #selector(dismissSplashScreenController), userInfo: nil, repeats: false)
    }
    @objc func dismissSplashScreenController() {
        GMSServices.provideAPIKey(SecretKeys.googleKey)
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        
        // force signout
        //try? Auth.auth().signOut()
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let _ = AppDelegate.authservice.getCurrentUser() {
            window?.rootViewController = TabBarController()
            //UITabBar.appearance().backgroundColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
            //UITabBar.appearance().tintColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
            UITabBar.appearance().unselectedItemTintColor = UIColor.darkGray
            //. UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.6968343854, green: 0.1091536954, blue: 0.9438109994, alpha: 1)
            UITabBar.appearance().unselectedItemTintColor = UIColor.darkGray
            UINavigationBar.appearance().backgroundColor = UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1)
//            UINavigationBar.appearance().barTintColor = UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1)
            UINavigationBar.appearance().largeTitleTextAttributes  = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            //            UITabBar.appearance().unselectedItemTintColor = UIColor.darkGray
            
            //            window?.makeKeyAndVisible()
        } else {
            let storyboard = UIStoryboard(name: "LoginView", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            window?.rootViewController = UINavigationController(rootViewController: loginViewController)
        }
        UINavigationBar.appearance().backgroundColor = UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1)
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().largeTitleTextAttributes  = [NSAttributedString.Key.foregroundColor: UIColor.white]
        window?.makeKeyAndVisible()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print("Request Authorization Error: \(error)")
            } else if granted{
                print("Authorization Granted")
            } else{
                print("User Denied")
            }
        }
        self.window!.tintColor = #colorLiteral(red: 0.5921568627, green: 0.02352941176, blue: 0.737254902, alpha: 1)
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


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.userInfo)
        return completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        return completionHandler([.alert, .badge, .sound])
    }
}
