//
//  MessageView.swift
//  RandPeople
//
//  Created by Mac on 1.09.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Firebase

class MessageView: Navbar {
    private var leftButton = UIButton()
    private var rightButton = UIButton()
    private var labelforNavBar = UILabel()
    private var tableView = UITableView()
    private var senderArray = [RandPeople]()
    private var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       NotificationCenter.default.addObserver(self, selector: #selector(MessageView.postDelete), name: NSNotification.Name(rawValue: "postDelete"), object: nil)
        print("current date : \(Date())")
        getRandPeople()
        setupViews()
        setupFrameWithPhone(withdeviceName: .Hata)
    }
    @objc func postDelete(){
        if self.senderArray.count > 0 {
            self.senderArray.remove(at: self.selectedIndex)
            self.tableView.reloadData()
        }
    }
    private func getRandPeople(){
        let db = Firestore.firestore()
        db.collection("RandPeople").document("Peoples").collection(getUserUUID()).getDocuments { (document, error) in
            if error == nil {
                for document in document!.documents {
                    print(document.documentID)
                    print(document.data())
                    print("veriler var")
                    let data = document.data()
                    let randpeople = RandPeople()
                    randpeople.senderID = document.documentID
                    randpeople.imageURL = data["imageURL"] as! String
                    let deger = self.compareDate(withDate: data["sentDate"] as! Timestamp)
                    if deger == false {
                        self.senderArray.append(randpeople)
                        self.tableView.reloadData()
                    }
                }
            }else {print(error!.localizedDescription)}
        }
    }
    private func compareDate(withDate:Timestamp)->Bool{
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDateF = dateFormatter.string(from: currentDate)
        let comingDateF = dateFormatter.string(from: withDate.dateValue())
        print("CurrentDate: \(currentDateF)" )
        print("ComingDate: \(comingDateF)")
        if currentDateF ==  comingDateF{
            return false
        }else {
            return true
        }
    }
}

extension MessageView : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.senderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MessagesCell else {fatalError("error")}
        let view = UIView()
        view.backgroundColor = .white
        cell.selectedBackgroundView = view
        cell.userId.text = self.senderArray[indexPath.row].senderID
        cell.uıimageView.sd_setImage(with: URL(string: self.senderArray[indexPath.row].imageURL), completed: nil)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedIndex = indexPath.row
        PeopleShowView.instance.setterOfrandPeople(withID: self.senderArray[indexPath.row].senderID)
        PeopleShowView.instance.showAlert()
        PeopleShowView.instance.setImage(with: self.senderArray[indexPath.row].imageURL)
    }
}
extension MessageView : SetUpViews{
    func setupViews() {
        labelforNavBar = {
            let navbarLAbel = UILabel()
            navbarLAbel.text = "Gelen Randların.."
            return navbarLAbel
        }()
        tableView = {
           let tableView = UITableView()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.register(MessagesCell.self, forCellReuseIdentifier: "cell")
            return tableView
        }()
        leftButton = {
           let leftButton = UIButton()
            // image gelecek burayada
//           leftButton.setTitle("Camera", for: .normal)
            leftButton.setBackgroundImage(UIImage(named: "CameraButton"), for: .normal)
            leftButton.addTarget(self, action: #selector(MessageView.setPicker), for: .touchUpInside)
           return leftButton
        }()
        rightButton = {
           let rightButton = UIButton()
            rightButton.setBackgroundImage(UIImage(named: "MessageButton"), for: .normal)
            rightButton.addTarget(self, action: #selector(MessageView.navigateToMessages), for: .touchUpInside)
            
            return rightButton
        }()
    }
    
    func setupFrameWithPhone(withdeviceName: PhoneType) {
            labelforNavBar.frame = CGRect(x: (screenWith  / 2 ) - 76, y: 40, width: 200, height: 40)
            tableView.frame = CGRect(x: 0, y: 90, width: screenWith, height: screenHeigth - 90)
            leftButton.frame = CGRect(x: 10, y: 40, width: 50, height: 40)
            rightButton.frame = CGRect(x: screenWith - 60, y: 40, width: 50, height: 40)
        
        self.view.addSubview(rightButton)
        self.view.addSubview(leftButton)
        self.view.addSubview(tableView)
        self.view.addSubview(labelforNavBar)
    }
    @objc func setPicker(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType  = .photoLibrary // normalde camera olacak
        picker.allowsEditing = false
        self.present(picker,animated: true,completion: nil)
    }
    @objc func navigateToMessages(){
        self.navigationController?.pushViewController(ChatView(), animated: true)
    }
}
extension MessageView :UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selected = info[.originalImage] as? UIImage else {fatalError("error")}
        print(selected)
        GeneralClasses.referance.sentImages(with: selected)
        self.dismiss(animated: true, completion: nil)
    }
}
