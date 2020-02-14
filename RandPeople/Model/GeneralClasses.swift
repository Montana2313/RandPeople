//
//  GeneralClasses.swift
//  RandPeople
//
//  Created by Mac on 3.09.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import Firebase
import SVProgressHUD

class GeneralClasses {
    static let referance = GeneralClasses()
    
    func postFirstScreen(withUserID:String , andHobby:[String] , clousure:@escaping ()->Void){
        let db = Firestore.firestore()
        let values = ["userhobbies":andHobby,"userActive":true] as [String : Any]
        db.collection("UserInfos").document(withUserID).setData(values) { (error) in
            if error == nil {
                clousure()
            }
        }
    }
    func getUserIsActive(isActive:@escaping(Bool)->Void){
        let db = Firestore.firestore()
        db.collection("UserInfos").document(getUserUUID()).getDocument { (doc, err) in
            if err == nil {
                if let data = doc?.data(){
                    isActive(data["userActive"] as? Bool ?? true)
                }
            }
        }
            
    }
    func sentImages(with:UIImage){
        SVProgressHUD.show()
        let currentuserId = getUserUUID()
        getWholeUser { (peopeID) in
            print("sonlandı")
            let alici = self.getrandomPeople(withWholePeople: peopeID, currentUserId: currentuserId)
            print(alici)
            print("alici belirlendi")
            self.sentURL(with: with, closure: { (urlOfImage) in
                let values = ["imageURL":urlOfImage,"sentDate":Date()] as [String : Any]
                let db = Firestore.firestore()
            db.collection("RandPeople").document("Peoples").collection(alici).document(currentuserId).setData(values, completion: { (error) in
                    if error == nil{
                        
                    }
                })
            })
            
        }
    }
    private func sentURL(with image:UIImage,closure:@escaping (String)->Void){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let mediaobject = storageRef.child("media")
        if let data = image.jpegData(compressionQuality: 0.5){
            let uuid = NSUUID().uuidString
            let mediaimage = mediaobject.child("\(uuid).jpg")
            mediaimage.putData(data, metadata: nil) { (storageData, error) in
                if error == nil {
                    mediaimage.downloadURL(completion: { (url, error2) in
                        if error2 == nil {
                            closure(url!.absoluteString)
                        }else {
                            print(error2?.localizedDescription as Any)
                        }
                    })
                }else{
                    print(error?.localizedDescription as Any)
                }
            }
        }
    }
    private func getrandomPeople(withWholePeople : [String] , currentUserId:String)->String{
        let number = Int.random(in: 0 ..< withWholePeople.count)
        var currentRandomPeople = withWholePeople[number]
        while currentRandomPeople == currentUserId {
            let numberRand = Int.random(in: 0 ..< withWholePeople.count)
            currentRandomPeople = withWholePeople[numberRand]
        }
        
        return currentRandomPeople
    }
    private func getWholeUser(clousre:@escaping ([String])->Void){
        let db = Firestore.firestore()
        var wholeUsers = [String]()
        db.collection("UserInfos").getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                   wholeUsers.append(document.documentID)
                }
                clousre(wholeUsers)
            }
        }
    }
}
