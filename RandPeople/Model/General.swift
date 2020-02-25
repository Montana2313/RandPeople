//
//  General.swift
//  RandPeople
//
//  Created by Mac on 1.09.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import UIKit

// Tanımlamalar
let screenWith = UIScreen.main.bounds.width
let screenHeigth = UIScreen.main.bounds.height
// Fonksiyonlar

func getDeviceModel() -> PhoneType {
    guard let appDel = UIApplication.shared.delegate as? AppDelegate else {fatalError("error")}
    let deviceModel : PhoneType = appDel.deviceModel()
    return deviceModel
}
func getUserUUID()->String {
    if let userUUID = UserDefaults.standard.string(forKey: "userID"){
        return userUUID
    }
    return ""
}
func getuserLoginFirst()->Bool{
    return UserDefaults.standard.bool(forKey:"userLogin")
}
//Protokoller
protocol CreateView {
    func MasterPage()
}
protocol SetUpViews {
    func setupViews()
    func setupFrameWithPhone(withdeviceName:PhoneType)
}

// Enum
enum PageType {
    case LoginScreen
    case FirstScreen
    case MessageView
    case ChatView
    case PersonalChatView
    case PrivarcyPolicy
    case EULA
    case Suspended
}
enum PhoneType {
    case iPhoneXR
    case iPhoneX
    case iPhoneXSMax
    case iPhone8Plus
    case iPhone8
    case iPhoneSE
    case Hata
}
enum LoginScreenStat{
    case login
    case singUp
}
class RandPeople {
    var senderID:String = ""
    var imageURL:String = ""
}
class MessageType {
    var senderID:String = ""
    var messsageText : String = ""
}
class Profil {
    var profilId:String = "" // username aynı anda
    var profilImageURL:String = ""
    var profileHobbies:[String]? = [String]()
    var profilisActive: Bool = true
    var profileisEULA : Bool = false
    var profileisPrivarcyPolicy : Bool = false
}
