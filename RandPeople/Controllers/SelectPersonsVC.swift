//
//  SelectPersonsVC.swift
//  RandPeople
//
//  Created by Mac on 14.02.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class SelectPersonsVC: UIViewController {
    private var leftBackButton = UIButton()
    private var tableView = UITableView()
    private var selectedImage : UIImage = UIImage()
    private var profilesArray : [Profil] = [Profil](){
        didSet{
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
        setupFrameWithPhone(withdeviceName: getDeviceModel())
        GeneralClasses.referance.getAllUserInfos { (profiles) in
            self.profilesArray = profiles
        }
    }
    func setSelectedImage(_ image:UIImage) {
        self.selectedImage = image
    }
}
extension SelectPersonsVC : SetUpViews{
    func setupViews() {
        tableView = {
           let tableView = UITableView()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.register(MessagesCell.self, forCellReuseIdentifier: "cell")
            tableView.backgroundColor = .clear
            return tableView
        }()
        leftBackButton = {
            let button = UIButton()
            button.setBackgroundImage(UIImage(named: "backButton"), for: .normal)
            button.frame = CGRect(x: 20, y: 35, width: 50, height: 50)
            button.addTarget(self, action: #selector(backButtoTapped), for: .touchUpInside)
            return button
        }()
    }
    func setupFrameWithPhone(withdeviceName: PhoneType) {
       tableView.frame = CGRect(x: 0, y: 90, width: screenWith, height: screenHeigth - 90)
        self.view.addSubview(tableView)
        self.view.addSubview(leftBackButton)
    }
    @objc func backButtoTapped(){
        // reklam gelecek
        self.navigationController?.popViewController(animated: true)
    }
}

extension SelectPersonsVC : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profilesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MessagesCell else {fatalError("error")}
        let view = UIView()
        view.backgroundColor = .clear
        cell.selectedBackgroundView = view
        cell.backgroundColor = .clear
        let stringArr = self.profilesArray[indexPath.row].profilId.components(separatedBy: "-")
        cell.userId.text = "User#\(String(describing: stringArr.last!))"
        if let url =  self.profilesArray[indexPath.row].profilImageURL{
             cell.uıimageView.sd_setImage(with: URL(string: url), completed: nil)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        SVProgressHUD.show()
        if let cgImage = self.selectedImage.cgImage{
            GeneralClasses.referance.contentChecker(cgImage) { (isOkay) in
                if isOkay == false {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Information", message: "Plesea select appropriate image", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Okay", style: .default) { (btn) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                }else {
                        GeneralClasses.referance.sentImages(personId: self.profilesArray[indexPath.row].profilId, self.selectedImage) {
                                SVProgressHUD.dismiss()
                                self.present(CreateAlert.referance.createAlert(withTitle: "Information", andMessage: "Sent", andActionTitle: "Okay"),animated: true,completion:{
                                    self.navigationController?.popViewController(animated: true)
                                })
                    
                            }
                }
            }
        }
    }
    
}
