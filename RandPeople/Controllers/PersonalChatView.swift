//
//  PersonalChatView.swift
//  RandPeople
//
//  Created by Mac on 2.09.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class PersonalChatView: Navbar {
    private var leftBackButton = UIButton()
    private var tableView = UITableView()
    private var bottomView = UIView()
    private var textfield = UITextField()
    private var sentButton = UIButton()
    private var selectedUSERID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(PersonalChatView.endEditing))
        self.view.addGestureRecognizer(gesture)
        setupViews()
        setupFrameWithPhone(withdeviceName: .Hata)
        // Do any additional setup after loading the view.
    }
    @objc func endEditing(){
        self.view.endEditing(true)
//        self.bottomView.removeFromSuperview()
//         bottomView.frame = CGRect(x: 0, y: screenHeigth - 100, width: screenWith, height: 150)
//        self.view.addSubview(bottomView)
    }
    func setUserID(withID:String){
        print("konuşunlan insan : \((withID))")
        selectedUSERID = withID
    }

}
extension PersonalChatView : SetUpViews{
    func setupViews() {
        leftBackButton = {
            let button = UIButton()
            button.setBackgroundImage(UIImage(named: "backButton"), for: .normal)
            button.addTarget(self, action: #selector(PersonalChatView.backButton), for: .touchUpInside)
            return button
        }()
        tableView = {
           let tableView = UITableView()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(FirstCell.self, forCellReuseIdentifier: "cell")
            return tableView
        }()
        bottomView = {
           let view = UIView()
           view.backgroundColor = UIColor(red:0.56, green:0.85, blue:0.82, alpha:1.0)
           return view
        }()
        textfield = {
            let textField = UITextField()
            textField.placeholder = "Mesaj içeriğiniz"
            textField.textAlignment = .center
            textField.backgroundColor = .white
            textField.layer.cornerRadius = view.frame.width/25.0
            textField.addTarget(self, action: #selector(PersonalChatView.myTargetFunction(textField:)), for: .touchDown)
            textField.clipsToBounds = true
            return textField
        }()
        sentButton = {
           let button = UIButton()
           button.setTitle("Gönder", for: .normal)
           button.setTitleColor(.black, for: .normal)
           button.backgroundColor = .white
            return button
        }()
    }
    
    func setupFrameWithPhone(withdeviceName: PhoneType) {
          leftBackButton.frame = CGRect(x: 15, y: 40, width: 40, height: 40)
          tableView.frame = CGRect(x: 0, y: 90, width: screenWith, height: screenHeigth - 200)
          bottomView.frame = CGRect(x: 0, y: screenHeigth - 100, width: screenWith, height: 150)
          textfield.frame = CGRect(x: 10, y: 20, width: screenWith - 150, height: 50)
          sentButton.frame = CGRect(x: screenWith - 120, y: 20, width: 100, height: 50)
          self.bottomView.addSubview(textfield)
          self.bottomView.addSubview(sentButton)
          self.view.addSubview(bottomView)
          self.view.addSubview(tableView)
          self.view.addSubview(leftBackButton)
    }
    @objc func backButton(){
        if self.navigationController?.viewControllers == nil{
            guard let appDel = UIApplication.shared.delegate as? AppDelegate else {fatalError("error")}
            appDel.open_Page(withPage: .MessageView, withParam:"")
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func myTargetFunction(textField: UITextField) {
        print("focus on text")
//        bottomView.frame = CGRect(x: 0, y: screenHeigth - 450, width: screenWith, height: screenHeigth)
//        tableView.addSubview(bottomView)
    }
}
extension PersonalChatView : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? FirstCell else {fatalError("error")}
        cell.isUserInteractionEnabled = false
        cell.CommenterName.text = "Mesajlaşma örneği."
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}

