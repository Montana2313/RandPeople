//
//  ChatView.swift
//  RandPeople
//
//  Created by Mac on 1.09.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Firebase

class ChatView: Navbar {
    private var leftBackButton = UIButton()
    private var chatTableView = UITableView()
    private var personTalkArray = [String]()
    private var personTalkDate = [Timestamp]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.95, green:0.99, blue:0.99, alpha:1.0)
        getPerson()
        setupViews()
        setupFrameWithPhone(withdeviceName: .Hata)
    }
    private func getPerson(){
        let db = Firestore.firestore()
        db.collection("MesajInfos").document("Infos").collection(getUserUUID()).getDocuments { (document, error) in
            if error == nil {
                for document in document!.documents {
                    print(document.documentID)
                    print(document.data())
                    let data = document.data()
                    print("veriler var")
                    let status = self.compareDate(withDate: data["dateOfAccept"] as! Timestamp)
                    if status == false {
                        self.personTalkArray.append(document.documentID)
                        self.personTalkDate.append(data["dateOfAccept"] as! Timestamp)
                        self.chatTableView.reloadData()
                    }
                }
            }else {print(error!.localizedDescription)}
        }
    
    }
}
extension ChatView:SetUpViews{
    func setupViews() {
        leftBackButton = {
           let button = UIButton()
           button.setBackgroundImage(UIImage(named: "backButton"), for: .normal)
            button.addTarget(self, action: #selector(ChatView.backButton), for: .touchUpInside)
            return button
        }()
        chatTableView = {
           let tableView = UITableView()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.register(FirstCell.self, forCellReuseIdentifier: "cell")
            tableView.backgroundColor = .clear
            return tableView
        }()
    }
    
    func setupFrameWithPhone(withdeviceName: PhoneType) {
        
         leftBackButton.frame = CGRect(x: 15, y: 40, width: 40, height: 40)
         chatTableView.frame = CGRect(x: 0, y: 90, width: screenWith, height: screenHeigth - 90)
        self.view.addSubview(leftBackButton)
        self.view.addSubview(chatTableView)
    }
    @objc func backButton(){
        // reklam gelecek
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension ChatView : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.personTalkArray.count > 0 {
            return self.personTalkArray.count
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.personTalkArray.count > 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? FirstCell else {fatalError("error")}
            cell.backgroundColor = .clear
            // eğer userID var ise rengi daha farklı olacak
             let stringArr = self.personTalkArray[indexPath.row].components(separatedBy: "-")
            cell.CommenterName.text = "User#\(String(describing: stringArr.last!))"
            cell.CommenterName.sizeToFit()
            cell.CommenterName.textAlignment = .center
            return cell
        }else {
            self.chatTableView.register(NoResultCell.self, forCellReuseIdentifier: "cellNo")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellNo") as? NoResultCell else {fatalError("error")}
            // daha güzel bir cell tasarla
            // no result found adı
            cell.backgroundColor = .clear
            cell.CommenterName.text = "Konuşma geçmişi bulamadık"
            cell.CommenterName.textAlignment = .center
            cell.isUserInteractionEnabled = false
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let personalView = PersonalChatView()
        personalView.setUserID(withID: self.personTalkArray[indexPath.row])
        personalView.setAdStat(true)
        self.navigationController?.pushViewController(personalView, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}
