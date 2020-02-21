//
//  ProfileVC.swift
//  RandPeople
//
//  Created by Mac on 14.02.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class ProfileVC: UIViewController {
    private var leftBackButton = UIButton()
    private var user:Profil = Profil(){
        didSet{
            self.userHobbiesTableView.reloadData()
            let stringArr = self.user.profilId.components(separatedBy: "-")
            self.userName.text = "User#\(String(describing: stringArr.last!))"
            if let url = self.user.profilImageURL{
                self.userImageView.sd_setImage(with: URL(string: url), completed: nil)
            }
        }
    }
    private var userId:String = ""
    private var userImageView : UIImageView = UIImageView()
    private var anaView : UIView = UIView()
    private var userName:UILabel = UILabel()
    private var userHobbiesView : UIView = UIView()
    private var userHobbiesTableView : UITableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.56, green:0.85, blue:0.82, alpha:1.0)
        setupViews()
        setupFrameWithPhone(withdeviceName: getDeviceModel())
    }
    func setUserInfos(_ id : String){
        self.userId = id
        GeneralClasses.referance.getUserInfos(id: userId) { (userProfil) in
            self.user = userProfil
        }
    }
}
extension ProfileVC : SetUpViews{
    func setupViews() {
        self.anaView = {
            let view = UIView()
            view.backgroundColor = .white
            view.frame = CGRect(x: 0, y: screenHeigth + 150, width: screenWith , height: screenHeigth - 150)
            view.layer.masksToBounds = true
            view.clipsToBounds = true
            view.layer.cornerRadius = view.frame.size.width / 25.0
            return view
        }()
        leftBackButton = {
            let button = UIButton()
            button.setBackgroundImage(UIImage(named: "backButton"), for: .normal)
            button.frame = CGRect(x: 20, y: 40, width: 50, height: 50)
            button.addTarget(self, action: #selector(backButtoTapped), for: .touchUpInside)
            return button
        }()
        self.userImageView = {
           let imageView = UIImageView()
            imageView.image = UIImage(named: "profilDefault.png")
            imageView.frame = CGRect(x: (self.anaView.frame.size.width / 2) - 50, y: 75, width: 100, height: 100)
            imageView.layer.borderWidth = 0.4
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.masksToBounds = true
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = imageView.frame.size.width / 2.0
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePickerTapped)))
           return imageView
        }()
        self.userName = {
            let lbl = UILabel()
            let stringArr = self.user.profilId.components(separatedBy: "-")
            lbl.text = "User#\(String(describing: stringArr.last!))"
            lbl.textAlignment = .center
            lbl.textColor = .black
            lbl.font = UIFont(name: "Helvetica", size: 15.0)
            lbl.frame = CGRect(x: 10, y: 50, width: screenWith - 20, height: 50)
            return lbl
        }()
        self.userHobbiesView = {
            let view = UIView()
            view.backgroundColor = UIColor(red:0.56, green:0.85, blue:0.82, alpha:1.0)
            view.frame = CGRect(x: 20, y: 100, width: self.anaView.frame.size.width - 40 , height: self.anaView.frame.size.height - 250)
            view.layer.masksToBounds = true
            view.clipsToBounds = true
            view.layer.cornerRadius = view.frame.size.width / 25.0
            return view
        }()
        self.userHobbiesTableView = {
           let tbView = UITableView()
            tbView.delegate = self
            tbView.dataSource = self
            tbView.backgroundColor = .clear
            tbView.separatorStyle = .none
            
            tbView.frame = CGRect(x: 0, y: 0, width: self.userHobbiesView.frame.size.width, height: self.userHobbiesView.frame.size.height)
            return tbView
        }()
        self.view.addSubview(self.userImageView)
        self.view.addSubview(self.leftBackButton)
        self.userHobbiesView.addSubview(self.userHobbiesTableView)
        self.anaView.addSubview(self.userHobbiesView)
        self.anaView.addSubview(self.userName)
        self.view.addSubview(self.anaView)
        self.view.bringSubviewToFront(self.userImageView)
    }
    @objc func backButtoTapped(){
        // reklam gelecek
        self.navigationController?.popViewController(animated: true)
    }
    func setupFrameWithPhone(withdeviceName: PhoneType) {
        UIView.animate(withDuration: 1.0) {
            self.anaView.frame = CGRect(x: 0, y: 150, width: screenWith , height: screenHeigth - 150)
        }
    }
    @objc func imagePickerTapped(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType  = .photoLibrary
        picker.allowsEditing = true
        self.present(picker,animated: true,completion: nil)
    }
}
extension ProfileVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let hobbies = self.user.profileHobbies{
            return hobbies.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let hobbies = self.user.profileHobbies{
            let cell = UITableViewCell()
            cell.textLabel?.text = hobbies[indexPath.row]
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .clear
            return cell
        }
        return UITableViewCell()
    }
    
    
}
extension ProfileVC :UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selected = info[.originalImage] as? UIImage else {fatalError("error")}
        print(selected)
        SVProgressHUD.show()
        if let cgImage = selected.cgImage{
            GeneralClasses.referance.contentChecker(cgImage) { (isOkay) in
                if isOkay == false {
                    SVProgressHUD.dismiss()
                    self.dismiss(animated: true, completion: nil)
                    let alert = UIAlertController(title: "Information", message: "Plesea select appropriate image", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                }else {
                    GeneralClasses.referance.sentURL(with: selected) { (urlString) in
                        self.user.profilImageURL = urlString
                        if let hobbies = self.user.profileHobbies{
                            GeneralClasses.referance.updateUserInfos(userId: self.user.profilId, hobbies: hobbies, imageURL: self.user.profilImageURL!) {
                                    SVProgressHUD.dismiss()
                                    self.userImageView.image = selected
                                    self.dismiss(animated: true, completion: nil)
                            }
                        }else {
                            GeneralClasses.referance.updateUserInfos(userId: self.user.profilId, hobbies: [""], imageURL: self.user.profilImageURL!) {
                                SVProgressHUD.dismiss()
                                self.userImageView.image = selected
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                       
                    }
                }
            }
        }
        
    }
}
