//
//  LoginScreen.swift
//  RandPeople
//
//  Created by Mac on 24.02.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginScreen: UIViewController {
    private var status : LoginScreenStat = .login
    private var AppName : UILabel = UILabel()
    private var myLogo : UIImageView = UIImageView()
    private var loginButton : UIButton = UIButton()
    private var singUpButton : UIButton = UIButton()
    // login
    private var loginView : UIView = UIView()
    private var loginUserEmailTextField = UITextField()
    private var loginPasswordTextfield = UITextField()
    private var loginForgerPasswordLabel :  UILabel = UILabel()
    // kayit
    private var singUpView : UIView = UIView()
    private var singUpUserEmailTextField = UITextField()
    private var singUpPasswordTextField = UITextField()
    private var singUpPasswordTextfieldControl = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.56, green:0.85, blue:0.82, alpha:1.0)
        setupViews()
        setupFrameWithPhone(withdeviceName: getDeviceModel())
        animateSetup(withdeviceName: getDeviceModel())
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditingView)))
    }
    @objc func endEditingView(){
        self.view.endEditing(true)
    }
    @objc func singUpButtonTapped(){
        if self.status == .login{
            // view yukarı taşınacak
            UIView.animate(withDuration: 1.0) {
                self.singUpView.frame = CGRect(x: 20, y: (screenHeigth / 2) - 150, width: screenWith - 40, height: 300)
                self.loginView.frame = CGRect(x: 20, y: screenHeigth + 100, width: screenWith - 40, height: 300)
                self.changeButtons()
            }
            
            self.status = .singUp
        }else {
            // kayıt işlemi
            SVProgressHUD.show()
            if self.singUpUserEmailTextField.text != "" && self.singUpPasswordTextField.text != "" && self.singUpPasswordTextfieldControl.text != ""{
                if self.singUpPasswordTextField.text == self.singUpPasswordTextfieldControl.text {
                    if self.singUpPasswordTextField.text!.count > 8 {
                        if self.singUpUserEmailTextField.text!.contains("@") {
                            self.singUpUserEmailTextField.text = self.singUpUserEmailTextField.text?.lowercased()
                            User.instance.createUser(email: self.singUpUserEmailTextField.text!, password: self.singUpPasswordTextField.text!) { (isUser) in
                                if isUser == true{
                                    SVProgressHUD.dismiss()
                                    guard let appDel = UIApplication.shared.delegate as? AppDelegate else {fatalError()}
                                    appDel.open_Page(withPage: .FirstScreen, withParam:nil)
                                }else {
                                    self.present(CreateAlert.referance.createAlert(withTitle: "Informations", andMessage: "User exists", andActionTitle: "Okay")
                                    ,animated: true,completion: nil)
                                    SVProgressHUD.dismiss()
                                }
                            }
                        }else {
                            print("Geçerli bir email adresini giriniz")
                           self.present(CreateAlert.referance.createAlert(withTitle: "Informations", andMessage: "Please enter a valid email address", andActionTitle: "Okay")
                           ,animated: true,completion: nil)
                                    SVProgressHUD.dismiss()
                        }
                    }else {
                        print("En az 8 karakter içerecek bir şifre girinix")
                        self.present(CreateAlert.referance.createAlert(withTitle: "Informations", andMessage: "Password must contain at least 8 characters", andActionTitle: "Okay")
                        ,animated: true,completion: nil)
                            SVProgressHUD.dismiss()
                    }
                }else {
                    print("Şifreler uyuşmuyor")
                    self.present(CreateAlert.referance.createAlert(withTitle: "Informations", andMessage: "Passwords do not match", andActionTitle: "Okay")
                    ,animated: true,completion: nil)
                            SVProgressHUD.dismiss()
              
                }
            }else {
                    print("Boş alanlar mecut")
                    self.present(CreateAlert.referance.createAlert(withTitle: "Informations", andMessage: "Please fill the blank", andActionTitle: "Okay")
                    ,animated: true,completion: nil)
                      SVProgressHUD.dismiss()
            }
        }
    }
    @objc func loginButtonTapped(){
        if self.status == .singUp{
            UIView.animate(withDuration: 1.0) {
                self.loginView.frame = CGRect(x: 20, y: (screenHeigth / 2) - 150, width: screenWith - 40, height: 300)
                self.singUpView.frame = CGRect(x: 20, y: screenHeigth + 100, width: screenWith - 40, height: 300)
                self.changeButtons()
            }
            self.status = .login
        }else {
            SVProgressHUD.show()
            if self.loginUserEmailTextField.text != "" && self.loginPasswordTextfield.text != ""
            {
                self.loginUserEmailTextField.text = self.loginUserEmailTextField.text?.lowercased()
                User.instance.login(email: self.loginUserEmailTextField.text!, password: self.loginPasswordTextfield.text!) { (isUser) in
                    if isUser == true {
                        GeneralClasses.referance.getUserInfos(id: getUserUUID()) { (profil) in
                            SVProgressHUD.dismiss()
                            if profil.profilisActive == true {
                                if profil.profileHobbies != nil{
                                    UserDefaults.standard.set(profil.profileHobbies!, forKey: "userHobby")
                                    UserDefaults.standard.synchronize()
                                    if profil.profileisEULA == true{
                                        UserDefaults.standard.set(true, forKey: "EUCLA")
                                        UserDefaults.standard.synchronize()
                                        if profil.profileisPrivarcyPolicy == true{
                                            UserDefaults.standard.set(true, forKey: "PrivarcyPolicy")
                                            UserDefaults.standard.synchronize()
                                            guard let appDel = UIApplication.shared.delegate as? AppDelegate else {fatalError()}
                                            appDel.open_Page(withPage:.MessageView, withParam: nil)
                                        }else {
                                            guard let appDel = UIApplication.shared.delegate as? AppDelegate else {fatalError()}
                                            appDel.open_Page(withPage:.PrivarcyPolicy, withParam: nil)
                                        }
                                    }else {
                                        guard let appDel = UIApplication.shared.delegate as? AppDelegate else {fatalError()}
                                        appDel.open_Page(withPage:.EULA, withParam: nil)
                                    }
                                }else {
                                    guard let appDel = UIApplication.shared.delegate as? AppDelegate else {fatalError()}
                                    appDel.open_Page(withPage:.FirstScreen, withParam: nil)
                                }
                            }else {
                                guard let appDel = UIApplication.shared.delegate as? AppDelegate else {fatalError()}
                                appDel.open_Page(withPage:.Suspended, withParam: nil)
                            }
                            // yarın burayı dene
                        }
                    }else {
                        self.present(CreateAlert.referance.createAlert(withTitle: "Informations", andMessage: "Wrong Mail/Password.Please try again.", andActionTitle: "Okay")
                        ,animated: true,completion: nil)
                        SVProgressHUD.dismiss()
                    }
                }
            }else {
                SVProgressHUD.dismiss()
                self.present(CreateAlert.referance.createAlert(withTitle: "Informations", andMessage: "Please fill in the blank", andActionTitle: "Okay")
                ,animated: true,completion: nil)

            }
        }
    }
    private func changeButtons(){
        if self.status == .login{
            // // singup basılmış
            self.loginButton.setTitleColor(.white, for: .normal)
            self.loginButton.backgroundColor = UIColor(red:0.56, green:0.85, blue:0.82, alpha:1.0)
            self.loginButton.layer.borderWidth = 1.0
            self.loginButton.layer.borderColor = UIColor.white.cgColor
            
            self.singUpButton.setTitleColor(UIColor(red:0.56, green:0.85, blue:0.82, alpha:1.0), for: .normal)
            self.singUpButton.backgroundColor = .white
        }
        else {
            // login basılmış
            self.singUpButton.setTitleColor(.white, for: .normal)
            self.singUpButton.backgroundColor = UIColor(red:0.56, green:0.85, blue:0.82, alpha:1.0)
            self.singUpButton.layer.borderWidth = 1.0
            self.singUpButton.layer.borderColor = UIColor.white.cgColor
            
            self.loginButton.setTitleColor(UIColor(red:0.56, green:0.85, blue:0.82, alpha:1.0), for: .normal)
            self.loginButton.backgroundColor = .white
        }
    }
    @objc func forgetLabelTapped(){
            let alert = UIAlertController(title: "Password reset", message: "Email address", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Email address"
            }
            let action = UIAlertAction(title: "Send password reset request", style: .default) { (UIAlertAction) in
                let textField = alert.textFields![0]
                if textField.text != ""{
                    if (textField.text?.contains("@"))!{
                        User.instance.resetPassword(withResetText:textField.text!) { (Result) in
                            if Result == false{
                                self.present(CreateAlert.referance.createAlert(withTitle: "Information", andMessage: "Please enter a valid email address", andActionTitle: "Okay"),animated: true,completion:{
                                    self.navigationController?.popViewController(animated: true)
                                })
                            }else {
                                self.present(CreateAlert.referance.createAlert(withTitle: "Information", andMessage: "Please check your mailbox", andActionTitle: "Okay"),animated: true,completion:{
                                    self.navigationController?.popViewController(animated: true)
                                })
                            }
                        }
                    }
                }
            }
            let removeAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(removeAction)
            self.present(alert,animated: true,completion: nil)
    }
}
extension LoginScreen : SetUpViews{
    func setupViews() {
        self.AppName = {
           let label  = UILabel()
            label.numberOfLines = 2
            label.textColor = .white
            label.text = "RandPeople"
            label.textAlignment = .center
            label.font = UIFont(name: "Helvetica", size: 60.0)
           return label
        }()
        self.myLogo = {
            let imageView = UIImageView(image: UIImage(named: "logoclear.png"))
            return imageView
        }()
        self.loginForgerPasswordLabel = {
            let label  = UILabel()
            label.numberOfLines = 2
            label.textColor = .white
            label.text = "Forget Passowrd?"
            label.textAlignment = .center
            label.font = UIFont(name: "Helvetica", size: 15.0)
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forgetLabelTapped)))
            return label
        }()
        self.loginButton = {
           let btn = UIButton()
           btn.setTitle("Login", for: .normal)
           btn.setTitleColor(UIColor(red:0.56, green:0.85, blue:0.82, alpha:1.0), for: .normal)
           btn.backgroundColor = .white
            btn.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
           return btn
        }()
        self.singUpButton = {
            let btn = UIButton()
            btn.setTitle("Sing Up", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = UIColor(red:0.56, green:0.85, blue:0.82, alpha:1.0)
            btn.layer.borderWidth = 1.0
            btn.layer.borderColor = UIColor.white.cgColor
            btn.addTarget(self, action: #selector(singUpButtonTapped), for: .touchUpInside)
            return btn
        }()
        self.loginView = {
           let view = UIView()
            view.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
            view.layer.borderWidth = 1.0
           view.layer.borderColor = UIColor.white.cgColor
            return view
        }()
        self.loginUserEmailTextField = {
           let txtField = UITextField()
           txtField.attributedPlaceholder = NSAttributedString(string: "E-email Address", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            txtField.backgroundColor = .clear
            txtField.layer.borderWidth = 3.0
            txtField.layer.borderColor = UIColor.white.cgColor
            txtField.keyboardType = .emailAddress
            txtField.textAlignment = .center
            return txtField
        }()
        self.loginPasswordTextfield = {
            let txtField = UITextField()
            txtField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            txtField.backgroundColor = .clear
            txtField.layer.borderWidth = 3.0
            txtField.layer.borderColor = UIColor.white.cgColor
            txtField.isSecureTextEntry = true
            txtField.textAlignment = .center
            return txtField
        }()
        //
        self.singUpView = {
           let view = UIView()
           view.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
            view.layer.borderWidth = 1.0
           view.layer.borderColor = UIColor.white.cgColor
            return view
        }()
        self.singUpUserEmailTextField = {
           let txtField = UITextField()
           txtField.attributedPlaceholder = NSAttributedString(string: "E-email Address", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            txtField.backgroundColor = .clear
            txtField.layer.borderWidth = 3.0
            txtField.layer.borderColor = UIColor.white.cgColor
            txtField.keyboardType = .emailAddress
            txtField.textAlignment = .center
            return txtField
        }()
        self.singUpPasswordTextField = {
            let txtField = UITextField()
            txtField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            txtField.backgroundColor = .clear
            txtField.layer.borderWidth = 3.0
            txtField.layer.borderColor = UIColor.white.cgColor
            txtField.isSecureTextEntry = true
            txtField.textAlignment = .center
            return txtField
        }()
        self.singUpPasswordTextfieldControl = {
            let txtField = UITextField()
            txtField.attributedPlaceholder = NSAttributedString(string: "Password again", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            txtField.backgroundColor = .clear
            txtField.layer.borderWidth = 3.0
            txtField.layer.borderColor = UIColor.white.cgColor
            txtField.isSecureTextEntry = true
            txtField.textAlignment = .center
            return txtField
        }()
        self.view.addSubview(self.AppName)
        self.view.addSubview(self.myLogo)
        self.view.addSubview(self.singUpButton)
        self.view.addSubview(self.loginButton)
        self.loginView.addSubview(self.loginUserEmailTextField)
        self.loginView.addSubview(self.loginPasswordTextfield)
        self.loginView.addSubview(self.loginForgerPasswordLabel)
        
        self.singUpView.addSubview(self.singUpUserEmailTextField)
        self.singUpView.addSubview(self.singUpPasswordTextField)
        self.singUpView.addSubview(self.singUpPasswordTextfieldControl)
        
        self.view.addSubview(self.loginView)
        self.view.addSubview(self.singUpView)
    }
    func setupFrameWithPhone(withdeviceName: PhoneType) {
        self.AppName.frame = CGRect(x: 10, y: (screenHeigth / 2) - 220, width: screenWith - 20, height: 60)
        self.myLogo.frame = CGRect(x: screenWith - 55, y: screenHeigth - 50, width: 60, height: 55)
        self.singUpButton.frame = CGRect(x: 40, y: screenHeigth + 150, width: screenWith - 80, height: 50)
        self.loginButton.frame = CGRect(x: 40, y: screenHeigth + 90, width: screenWith - 80, height: 50)
        
        self.loginView.frame = CGRect(x: 20, y: screenHeigth + 100, width: screenWith - 40, height: 300)
        self.loginUserEmailTextField.frame = CGRect(x: 10, y: (self.loginView.frame.size.height / 2) - 75, width: self.loginView.frame.size.width - 20, height: 50)
        self.loginPasswordTextfield.frame = CGRect(x: 10, y: (self.loginView.frame.size.height / 2) - 20, width: self.loginView.frame.size.width - 20, height: 50)
        self.loginForgerPasswordLabel.frame = CGRect(x: 10, y: (self.loginView.frame.size.height / 2) + 50, width: self.loginView.frame.size.width - 20, height: 30)
        //
        self.singUpView.frame = CGRect(x: 20, y: screenHeigth + 100, width: screenWith - 20, height: 300)
        
        self.singUpUserEmailTextField.frame = CGRect(x: 10, y: (self.singUpView.frame.size.height / 2) - 100, width: self.loginView.frame.size.width - 20, height: 50)
        self.singUpPasswordTextField.frame = CGRect(x: 10, y: (self.singUpView.frame.size.height / 2) - 40, width: self.loginView.frame.size.width - 20, height: 50)
        self.singUpPasswordTextfieldControl.frame = CGRect(x: 10, y: (self.singUpView.frame.size.height / 2) + 15, width: self.loginView.frame.size.width - 20, height: 50)
        
        self.loginButton.layer.masksToBounds = true
        self.loginButton.clipsToBounds = true
        self.loginButton.layer.cornerRadius = self.loginButton.frame.size.width / 25.0
        
        self.singUpButton.layer.masksToBounds = true
        self.singUpButton.clipsToBounds = true
        self.singUpButton.layer.cornerRadius = self.singUpButton.frame.size.width / 25.0
        
        self.loginView.layer.masksToBounds = true
        self.loginView.clipsToBounds = true
        self.loginView.layer.cornerRadius = self.loginView.frame.size.width / 25.0
        
        self.singUpView.layer.masksToBounds = true
        self.singUpView.clipsToBounds = true
        self.singUpView.layer.cornerRadius = self.loginView.frame.size.width / 25.0
    
    }
    func animateSetup(withdeviceName:PhoneType){
        UIView.animate(withDuration: 1.0) {
            self.singUpButton.frame = CGRect(x: 40, y: screenHeigth - 180, width: screenWith - 80, height: 50)
            self.loginButton.frame = CGRect(x: 40, y: screenHeigth - 120, width: screenWith - 80, height: 50)
            self.loginView.frame = CGRect(x: 20, y: (screenHeigth / 2) - 150, width: screenWith - 40, height: 300)
        }
    }
    
}
