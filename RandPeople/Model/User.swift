//
//  User.swift
//  RandPeople
//
//  Created by Mac on 24.02.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class User {
    
    static let instance  = User()
    
    func createUser(email : String , password : String,isUser :@escaping (Bool) -> Void)
    {
        Auth.auth().createUser(withEmail: email , password: password) { (currentUser, error) in
            if error == nil
            {
                if let isCreatedUser = currentUser{
                    UserDefaults.standard.set(isCreatedUser.user.uid, forKey: "userID")
                    UserDefaults.standard.synchronize()
                    isUser(true)
                }else {
                    isUser(false)
                }
            }
            else {isUser(false)}
        }
    }
    func resetPassword(withResetText : String , closure:@escaping (Bool)->Void){
        Auth.auth().sendPasswordReset(withEmail: withResetText) { (error) in
            if error != nil {
                closure(false)

            }else {
                closure(true);
            }
        }
    }
    private func sentEmail(withUsername:String,closure:@escaping(String)->Void){
        let db = Firestore.firestore()
        db.collection("Users").whereField("username", isEqualTo: withUsername).getDocuments { (snapshot, error) in
            if error == nil{
                if snapshot!.documents.count == 0 {
                    closure("")
                }else {
                    let item = snapshot!.documents.first
                    closure(item!["email"] as! String)
                }
            }
        }
    }
    func login(email : String , password : String , isUser : @escaping (Bool) -> Void)
    {
        Auth.auth().signIn(withEmail: email, password: password) { (currentUser, error) in
            if error == nil{
                if let activeUser = currentUser{
                    UserDefaults.standard.set(activeUser.user.uid, forKey: "userID")
                    UserDefaults.standard.synchronize()
                    isUser(true)
                }else {
                    isUser(false)
                }
            }
            else {
                isUser(false)
            }
        }
        
    }
    func logout(process : () -> Void)
    {
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.removeObject(forKey: "userHobby")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.removeObject(forKey: "EUCLA")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.removeObject(forKey: "PrivarcyPolicy")
        UserDefaults.standard.synchronize()
        try! Auth.auth().signOut()
        
        process()
    }
}
