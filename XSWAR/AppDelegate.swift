//
//  AppDelegate.swift
//  XSWAR
//
//  Created by Jigar Kanani on 05/02/21.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import Firebase
import FirebaseDatabase
import UserNotifications
import LocalAuthentication
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var storyboard = UIStoryboard()
    var deviceToken: String = ""
    var currentLocation = CLLocationCoordinate2D()
    var userSignUpData : UserSignUpData!
    var loginAccessToken: String = ""
    var dealerLoginData : DealerLoginData!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
//        TestFairy.begin("SDK-F1YhjPnv")
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 60

        storyboard = UIStoryboard(name: "Main", bundle: nil)

        GMSServices.provideAPIKey(GMS_MAP_KEY)
        GMSPlacesClient.provideAPIKey(GMS_MAP_KEY)
        
        if (UserDefaults.standard.value(forKey: "UserData")) != nil
        {
            let data = (UserDefaults.standard.value(forKey: "UserData"))
            let userSignUpData = try! UserSignUpData.init(data: data as! Data)
            appDelegate.userSignUpData = userSignUpData
        }
        if (UserDefaults.standard.value(forKey: "DUserData")) != nil
        {
            let data = (UserDefaults.standard.value(forKey: "DUserData"))
            let userSignUpData = try? newJSONDecoder().decode(DealerLoginData.self, from: data as! Data)
            appDelegate.dealerLoginData = userSignUpData
        }
        
        if #available(iOS 10.0, *)
        {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                                                                   
            UNUserNotificationCenter.current().requestAuthorization( options: authOptions, completionHandler: {_, _ in })
        }
        else
        {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
                
        NotificationCenter.default.addObserver(self,selector: #selector(self.tokenRefreshNotification),name: Notification.Name.InstanceIDTokenRefresh, object: nil)
        
        if UserDefaults.standard.object(forKey: "kAccessToken") != nil {
            deviceToken = UserDefaults.standard.object(forKey: "kAccessToken") as? String ?? ""
            print("kAccessToken ====",deviceToken)
        }
        
        self.setRoot()
        
        return true
    }
    
    // MARK: - Refersh Devices Token
    @objc func tokenRefreshNotification(notification: NSNotification)
    {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error
            {
                print("Error fetching remote instance ID: \(error)")
            }
            else if let result = result
            {
                print("Remote instance ID token: \(result.token)")
                
                appDelegate.deviceToken = result.token
                let desfault = UserDefaults.standard
                desfault.set(result.token, forKey: "kAccessToken")
                desfault.synchronize()
                print("InstanceID token: \(String(describing: result.token))")
            }
        }
    }
        
    
    // MARK: - Receive Notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])
    {
        print("userInfo :",userInfo)
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("will present",notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        print(response.notification.request.content.userInfo)
    }
    
    func setRoot()
    {
        if appDelegate.dealerLoginData != nil
        {
            let notificationVC = self.storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
            let navigation = UINavigationController(rootViewController: notificationVC)
            navigation.navigationBar.isHidden = true
            self.window?.rootViewController = navigation
            self.window?.makeKeyAndVisible()
        }
        else if appDelegate.userSignUpData != nil
        {
            let homeMainPageVC = self.storyboard.instantiateViewController(withIdentifier: "HomeMainPageVC") as! HomeMainPageVC
            let navigation = UINavigationController(rootViewController: homeMainPageVC)
            navigation.navigationBar.isHidden = true
            self.window?.rootViewController = navigation
            self.window?.makeKeyAndVisible()
        }
        else
        {
            let navigation = appDelegate.storyboard.instantiateViewController(withIdentifier: "navMain") as! UINavigationController
            self.window?.rootViewController = navigation
            self.window?.makeKeyAndVisible()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      // Pass device token to auth
        Auth.auth().setAPNSToken(deviceToken, type: .unknown)

      // Further handling of the device token if needed by the app
      // ...
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
        }
        // This notification is not auth related, developer should handle it.
    }
    
    internal func application(_ application: UIApplication, open url: URL,options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool
    {
        if Auth.auth().canHandle(url) {
            return true
        }
        return false
    }


    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

