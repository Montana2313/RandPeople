//
//  AppDelegate.swift
//  RandPeople
//
//  Created by Mac on 1.09.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    // user ilk girdiğinde userID oluşmakta sevdiği hobiler ile birlikte

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        window = UIWindow(frame: UIScreen.main.bounds)
        var viewcontrollerFirst = UIViewController()
        // Test verisi için
//        UserDefaults.standard.removeObject(forKey: "userID")
//        UserDefaults.standard.synchronize()
//        UserDefaults.standard.removeObject(forKey: "userHobby")
//        UserDefaults.standard.synchronize()
        if getUserUUID() == ""{
              viewcontrollerFirst = FirstScreen()
        }else {
            print("USERID VAR")
            print(getUserUUID())
            if UserDefaults.standard.bool(forKey: "EUCLA") == false {
                viewcontrollerFirst = EUCLAViewController()
            }else {
                if UserDefaults.standard.bool(forKey: "PrivarcyPolicy") == false {
                    viewcontrollerFirst = PrivarcyPolicyViewController()
                }else {
                    viewcontrollerFirst = MessageView()
                }
            }
        }
       
        let nav1 = UINavigationController()
        nav1.viewControllers = [viewcontrollerFirst]
        nav1.navigationBar.isHidden = true
        window!.rootViewController = nav1
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
   
    }

    func applicationWillTerminate(_ application: UIApplication) {
    
    }
    func deviceModel() -> PhoneType{
        let bounds = UIScreen.main.bounds
        let screenWidth = bounds.width
        let screenHeight = bounds.height
        if screenWidth == 414.0 && screenHeight == 896.0{
            return PhoneType.iPhoneXR
        }else if screenWidth == 375.0 && screenHeight == 812.0{
            return PhoneType.iPhoneX
        }else if screenWidth == 414.0 && screenHeight == 896.0 {
            return PhoneType.iPhoneXSMax
        }else if screenWidth == 414.0 && screenHeight == 736.0{
            return PhoneType.iPhone8Plus
        }else if screenWidth == 375.0 && screenHeight == 667.0{
            return PhoneType.iPhone8
        }else if screenWidth == 320.0 && screenHeight == 568.0{
            return PhoneType.iPhoneSE
        }else {
            return PhoneType.Hata
        }
    }
    func open_Page(withPage pagetype:PageType,withParam:String?){
        // yönlendirme işlemleri bura üzerinden yapılacak
        if pagetype == PageType.FirstScreen{
            let rootView:FirstScreen = FirstScreen()
            self.seguePage(withController: rootView)
        }else if pagetype == PageType.MessageView{
            let rootView:MessageView = MessageView()
            
            self.seguePage(withController: rootView)
        }else if pagetype == PageType.ChatView{
            let rootView:ChatView = ChatView()
            self.seguePage(withController: rootView)
        }else if pagetype == PageType.PersonalChatView {
            let rootView:PersonalChatView = PersonalChatView()
            rootView.setUserID(withID:withParam!)
            self.seguePage(withController: rootView)
        }else if pagetype == .PrivarcyPolicy{
            let rootView : PrivarcyPolicyViewController = PrivarcyPolicyViewController()
            self.seguePage(withController: rootView)
        }
        else if pagetype == .Suspended{
            let rootView : SuspendUserInfoVC = SuspendUserInfoVC()
            self.seguePage(withController: rootView)
        }
//        else if pagetype == PageType.ComingEvent{
//            let rootView:ComingEventVC = ComingEventVC()
//            self.seguePage(withController: rootView)
//        }else if pagetype == PageType.MenuContainer{
//            let rootView:Menu_VC = Menu_VC()
//            if let window = self.window{
//                UIView.transition(with: window, duration: 0.70, options: .transitionCurlUp, animations: {
//                    window.rootViewController = rootView
//                }, completion: nil)
//            }
//        }
    }
    private func seguePage(withController : UIViewController){
        if let window = self.window{
            UIView.transition(with: window, duration: 0.70, options: .transitionFlipFromTop, animations: {
                if withController.isKind(of: MessageView.classForCoder()){
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    let nav1 = UINavigationController()
                    nav1.viewControllers = [withController]
                    nav1.navigationBar.isHidden = true
                     self.window!.rootViewController = nav1
                     self.window?.makeKeyAndVisible()
                }else {
                   window.rootViewController = withController
                }
            }, completion: nil)
        }
    }


}

