//
//  PeopleShowView.swift
//  RandPeople
//
//  Created by Mac on 1.09.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import Firebase
//import Firebase
//import SVProgressHUD

class PeopleShowView: UIView{
    
    static let instance = PeopleShowView()
    private var anaview = UIView()
    private var imageView = UIImageView()
    private var closeButton = UIButton()
    private var confirmButton = UIButton()
    private var changeButton = UIButton()
    private var reportButton = UIButton()
    private var parentView = UIView()
    private var randId : String = ""
    private var imageURLString : String = ""
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    @objc func closeediting(){
        self.parentView.endEditing(true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Error occur show alerView")
    }
    private func setUpView(){
        parentView = {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: screenWith, height: screenHeigth)
            view.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
            return view
        }()
        anaview = {
            let view = UIView()
            view.frame = CGRect(x: 20, y:-1*screenHeigth , width: screenWith - 40, height: screenHeigth - 80)
            view.backgroundColor = .white
            view.layer.cornerRadius = view.frame.size.width / 25.0
            view.layer.masksToBounds = true
            view.clipsToBounds = true
            return view
        }()
        confirmButton = {
            let button = UIButton()
            button.setTitle("Let's talk!", for: .normal)
            button.backgroundColor = UIColor(red:0.40, green:0.83, blue:0.43, alpha:1.0)
            button.addTarget(self, action: #selector(PeopleShowView.directToMessage), for: .touchUpInside)
            return button
        }()
        reportButton = {
            let button = UIButton()
            button.setTitle("Inappropriate", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .red
            button.addTarget(self, action: #selector(PeopleShowView.reportButtonTapped), for: .touchUpInside)
            return button
        }()

//        changeButton = {
//           let button = UIButton()
//            button.setTitle("Değiştir", for: .normal)
//            button.backgroundColor = .red
//            return button
//        }()
        closeButton = {
            let button = UIButton()
            button.frame = CGRect(x: anaview.frame.size.width - 50, y: 10, width: 35, height: 35)
            button.addTarget(self, action: #selector(PeopleShowView.closeTapped), for: .touchUpInside)
            button.setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
            return button
        }()
        imageView = {
           let imageView = UIImageView()
           imageView.frame = CGRect(x: 0, y: 0, width: anaview.frame.size.width, height: anaview.frame.size.height)
            imageView.image = UIImage(named: "austin")
            imageView.contentMode = .scaleAspectFill
           return imageView
        }()
        confirmButton.frame = CGRect(x: 0, y: anaview.frame.size.height - 110, width: anaview.frame.size.width, height: 50)
        self.reportButton.frame = CGRect(x: 0, y: anaview.frame.size.height - 55, width: anaview.frame.size.width, height: 50)
        confirmButton.layer.cornerRadius = confirmButton.frame.size.width / 25.0
        confirmButton.layer.masksToBounds = true
        confirmButton.clipsToBounds = true
//        changeButton.frame = CGRect(x: 0, y: anaview.frame.size.height - 140, width: anaview.frame.size.width, height: 50)
        self.anaview.addSubview(imageView)
        self.anaview.addSubview(self.reportButton)
        self.anaview.addSubview(confirmButton)
//        self.anaview.addSubview(changeButton)
        self.anaview.addSubview(closeButton)
        self.parentView.addSubview(anaview)
    }
    func showAlert()
    {
        UIApplication.shared.keyWindow?.addSubview(self.parentView)
        UIView.animate(withDuration: 1.0) {
            self.anaview.frame = CGRect(x: 20, y:40, width: screenWith - 40, height: screenHeigth - 80)
        }
    }
    func setterOfrandPeople(withID:String){
        self.randId = withID
    }
    func setImage(with:String){
        self.imageURLString = with
        self.imageView.sd_setImage(with: URL(string: with), completed: nil)
    }
    @objc func closeTapped() {
        deleteIfCloseButtonTapped {
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "postDelete"), object: nil)
            self.parentView.removeFromSuperview()
        }
    }
    private func deleteIfCloseButtonTapped(closure:@escaping ()->Void){
        // burada silme işlemi gerçekleşecek
        let db = Firestore.firestore()
        db.collection("RandPeople").document("Peoples").collection(getUserUUID()).document(self.randId).delete { (error) in
            if error == nil{
                closure()
            }
        }
    }
    @objc func directToMessage(){
        guard let appdel = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("error")
        }
        let setValue = ["dateOfAccept":Date(),"acceptedBy":getUserUUID(),"accepTo":self.randId] as [String : Any]
        deleteIfCloseButtonTapped {
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "postDelete"), object: nil)
            let db = Firestore.firestore()
        db.collection("MesajInfos").document("Infos").collection(getUserUUID()).document(self.randId).setData(setValue)
        db.collection("MesajInfos").document("Infos").collection(self.randId).document(getUserUUID()).setData(setValue)
            self.parentView.removeFromSuperview()
            appdel.open_Page(withPage: .PersonalChatView,withParam:self.randId)
        }
    }
    @objc func reportButtonTapped(){
        let db = Firestore.firestore()
        let id:String = UUID().uuidString
        let setData = ["reportedBy":getUserUUID(),"reportTo":self.randId,"imageURL":self.imageURLString]
        db.collection("Reports").document(id).setData(setData)
        self.closeTapped()
        NotificationCenter.default.post(name: NSNotification.Name("report"), object: nil)
    }
    
}
