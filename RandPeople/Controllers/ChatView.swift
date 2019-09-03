//
//  ChatView.swift
//  RandPeople
//
//  Created by Mac on 1.09.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class ChatView: Navbar {
    private var leftBackButton = UIButton()
    private var chatTableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupFrameWithPhone(withdeviceName: .Hata)
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? FirstCell else {fatalError("error")}
        // eğer userID var ise rengi daha farklı olacak
        cell.CommenterName.text = "123ASD-FDSF231**********"
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
