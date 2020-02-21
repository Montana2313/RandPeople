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
import CoreML
import Vision

class GeneralClasses {
    static let referance = GeneralClasses()
    
    func contentChecker(_ image:CGImage,isOkay:@escaping(Bool)->Void){
        var sentableBool :Bool = true
        if let model = try? VNCoreMLModel(for: ObjectableContentModel().self.model){
            let request = VNCoreMLRequest(model: model) { (modelRequest, err) in
                if err == nil {
                    if let results = modelRequest.results as? [VNClassificationObservation]{
                        guard let firstItem = results.first else {fatalError()}
                        let conf = (firstItem.confidence) * 100
                        let rounded = Int(conf * 100) / 100
                        print("Model Result : \(firstItem.identifier)")
                        print("Model confidence : \(rounded)")
                        if firstItem.identifier != "Normal" && rounded > 95{
                            sentableBool = false
                        }else {
                            sentableBool = true
                        }
                    }
                }
            }
            let handler = VNImageRequestHandler(cgImage: image)
            do {
                try handler.perform([request])
                isOkay(sentableBool)
            }catch{
                print("Hata var kardeş")
            }
            
        }
        
        
    }
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
    func getUserInfos(id:String,userInfos:@escaping(Profil)->Void){
        let db = Firestore.firestore()
        let profil = Profil()
        db.collection("UserInfos").document(id).getDocument { (doc, err) in
            if err == nil {
                if let data = doc?.data(){
                    profil.profileHobbies = data["userhobbies"] as? [String] ?? nil
                    profil.profilId = doc!.documentID
                    profil.profilImageURL = data["imageURL"] as? String ?? nil
                    userInfos(profil)
                }
            }
        }
    }
    func sentImages(personId:String,_ image :UIImage,complition:@escaping()->Void){
        SVProgressHUD.show()
        let currentuserId = getUserUUID()
            self.sentURL(with: image, closure: { (urlOfImage) in
                let values = ["imageURL":urlOfImage,"sentDate":Date()] as [String : Any]
                let db = Firestore.firestore()
            db.collection("RandPeople").document("Peoples").collection(personId).document(currentuserId).setData(values, completion: { (error) in
                    if error == nil{
                        complition()
                    }else {
                        complition()
                    }
                })
            })
            
        
    }
    func updateUserInfos(userId:String , hobbies:[String],imageURL:String,clousure:@escaping()->Void){
        let db = Firestore.firestore()
        let values = ["userhobbies":hobbies,"userActive":true,"imageURL":imageURL] as [String : Any]
        db.collection("UserInfos").document(userId).setData(values) { (error) in
            if error == nil {
                clousure()
            }
        }
    }
     func sentURL(with image:UIImage,closure:@escaping (String)->Void){
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
    private func getAllUsernames(clousre:@escaping ([String])->Void){
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
    func getAllUserInfos(clousre:@escaping([Profil])->Void){
        let db = Firestore.firestore()
        var wholeUsers = [Profil]()
        db.collection("UserInfos").getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    let profil = Profil()
                    if getUserUUID() != document.documentID{
                        if document.data()["userActive"] as? Bool == true{
                            profil.profilId = document.documentID
                            profil.profilImageURL = document.data()["imageURL"] as? String ?? ""
                            wholeUsers.append(profil)
                        }
                    }
                }
                clousre(wholeUsers)
            }
        }
    }
    
}
