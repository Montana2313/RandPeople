//
//  FirstScreen.swift
//  RandPeople
//
//  Created by Mac on 1.09.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class FirstScreen: Navbar {
    private var navbarLabel = UILabel()
    private var navbarButton = UIButton()
    private var selectedList = [String]()
    private let Hobbies = ["Sport","Travel","Art","Film","Cars","Games","Tech","Music","Software","Nature","Space"]
    private var tableview = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.95, green:0.99, blue:0.99, alpha:1.0)
        setupViews()
        setupFrameWithPhone(withdeviceName: .iPhoneX)
    }
}
extension FirstScreen : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Hobbies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"firstcell") as? FirstCell else {fatalError("error")}
        cell.CommenterName.text = self.Hobbies[indexPath.row]
        cell.backgroundColor = UIColor(red:0.95, green:0.99, blue:0.99, alpha:1.0)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        if let currentCell = tableView.cellForRow(at: indexPath){
            if currentCell.accessoryType == .checkmark{
                if let index = self.selectedList.firstIndex(of: self.Hobbies[indexPath.row]){
                    self.selectedList.remove(at: index)
                }
                currentCell.accessoryType = .none
            }else {
                currentCell.tintColor = .white
                currentCell.accessoryType = .checkmark
                self.selectedList.append(self.Hobbies[indexPath.row])
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    
}
extension FirstScreen : SetUpViews{
    func setupViews() {
        navbarLabel = {
            let navbarLAbel = UILabel()
            navbarLAbel.text = "Let's start with your hobbies!!"
            return navbarLAbel
        }()
        navbarButton = {
           let button = UIButton()
           button.setTitle("Save", for: .normal)
           button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action: #selector(FirstScreen.saveButtonTapped), for: .touchUpInside)
            return button
        }()
        tableview = {
           let tableView = UITableView()
           tableView.delegate = self
           tableView.dataSource = self
           tableView.separatorStyle = .none
            tableView.backgroundColor = .clear
           tableView.register(FirstCell.self, forCellReuseIdentifier: "firstcell")
            tableView.backgroundColor = UIColor(red:0.95, green:0.99, blue:0.99, alpha:1.0)
            return tableView
        }()
    }
    
    func setupFrameWithPhone(withdeviceName: PhoneType) {
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("error")
        }
        let deviceModel = appDel.deviceModel()
      
        tableview.frame = CGRect(x: 0, y: 90, width: screenWith, height: screenHeigth - 90)
        if deviceModel == .iPhoneSE || deviceModel == .iPhone8{
            navbarLabel.frame = CGRect(x: (screenWith  / 2 ) - 140, y: 40, width: 250, height: 40)
            navbarButton.frame = CGRect(x: screenWith - 90, y: 40, width: 80, height: 40)
        }else {
            navbarLabel.frame = CGRect(x: (screenWith  / 2 ) - 125, y: 40, width: 250, height: 40)
            navbarButton.frame = CGRect(x: screenWith - 90, y: 40, width: 80, height: 40)
        }
        self.view.addSubview(navbarButton)
        self.view.addSubview(tableview)
        self.view.addSubview(navbarLabel)
    }
    @objc func saveButtonTapped(){
         print("Save button tapped")
        self.navbarButton.isEnabled = false
         print(self.selectedList)
        if selectedList.count == 0{
           self.present( CreateAlert.referance.createAlert(withTitle: "Information", andMessage: "Select your hobbies", andActionTitle: "Okay"),animated: true,completion: nil)
            self.navbarButton.isEnabled = false
        }else if selectedList.count < 3 {
            self.present( CreateAlert.referance.createAlert(withTitle: "Information", andMessage: "You must choose at least 3 hobbies", andActionTitle: "Okay"),animated: true,completion: nil)
            self.navbarButton.isEnabled = false
        }
        // bir kere açıldıktan sonra bir daha bu ekrena gelmeyecek
        SVProgressHUD.show()
        let newUUID = NSUUID().uuidString
        UserDefaults.standard.set(newUUID, forKey: "userID")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(self.selectedList, forKey: "userHobby")
        UserDefaults.standard.synchronize()
        GeneralClasses.referance.postFirstScreen(withUserID: newUUID, andHobby: self.selectedList) {
            SVProgressHUD.dismiss()
             self.navigationController?.pushViewController(EUCLAViewController(), animated: true)
        }
    }
}
