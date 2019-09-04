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
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    print("veriler var")
//                    let data = document.data()
                    self.personTalkArray.append(document.documentID)
                    self.chatTableView.reloadData()
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
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension ChatView : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.personTalkArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? FirstCell else {fatalError("error")}
        // eğer userID var ise rengi daha farklı olacak
        cell.CommenterName.text = self.personTalkArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let personalView = PersonalChatView()
        self.navigationController?.pushViewController(personalView, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}
