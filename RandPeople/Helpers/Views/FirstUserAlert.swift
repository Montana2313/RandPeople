//
//  FirstUserAlert.swift
//  RandPeople
//
//  Created by Mac on 23.11.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import UIKit

class FirstUserAlertView: UIView {
        static let instance = FirstUserAlertView()
        private var parentView = UIView()
        private var explainLabel1 = UILabel()
        private var explainLabel2 = UILabel()
        private var doneButton = UIButton()
        private var leftImage = UIImageView()
        private var rigthImage = UIImageView()
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUpView()
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("Error occur show alerView")
        }
        private func setUpView(){
            parentView = {
                let view = UIView()
                view.frame = CGRect(x: -500 , y: (screenWith / 2) - 40, width: screenWith - 40, height: 500)
                view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
                view.layer.borderWidth = 1.0
                view.layer.cornerRadius = view.frame.size.width / 25.0
                view.layer.masksToBounds = true
                view.clipsToBounds = true
                return view
            }()
            self.explainLabel1 = {
                let label = UILabel()
                label.text = "You can send a picture to someone who has the same hobbies with the button above"
                label.textAlignment = .center
                label.frame = CGRect(x: 5, y: 70, width: self.parentView.frame.size.width - 10, height: 100)
                label.numberOfLines = 4
                label.textColor = .black
                return label
            }()
            self.explainLabel2 = {
                let label = UILabel()
                label.text = "You can talk to the people you accept during the day with the button above.But,Messages will be deleted within 24 hours :)"
                label.textAlignment = .center
                label.numberOfLines = 4
                label.textColor = .black
                label.frame = CGRect(x: 5, y: 240, width: self.parentView.frame.size.width - 10, height: 100)
                return label
            }()
            self.leftImage = {
               let imageview = UIImageView()
                imageview.image = UIImage(named: "CameraButton.png")
                imageview.frame = CGRect(x: (screenWith / 2) - 50, y: 10, width: 50, height: 50)
                return imageview
            }()
            self.rigthImage = {
               let imageview = UIImageView()
                imageview.image = UIImage(named: "MessageButton.png")
                imageview.frame = CGRect(x: (screenWith / 2) - 50, y: 180, width: 50, height: 50)
                return imageview
            }()
            self.doneButton = {
               let button = UIButton()
                button.setTitle("Start!", for: .normal)
                button.backgroundColor = UIColor(red:0.56, green:0.85, blue:0.82, alpha:1.0)
                button.setTitleColor(.black, for: .normal)
                button.frame = CGRect(x: 20, y: 360, width: self.parentView.frame.size.width - 40, height: 50)
                button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
                return button
            }()
            self.parentView.addSubview(self.explainLabel1)
            self.parentView.addSubview(self.explainLabel2)
            self.parentView.addSubview(self.leftImage)
            self.parentView.addSubview(self.rigthImage)
            self.parentView.addSubview(self.doneButton)
        }
        func showAlert()
        {
            UIApplication.shared.keyWindow?.addSubview(self.parentView)
            UIView.animate(withDuration: 1.0) {
                self.parentView.frame = CGRect(x: 20, y: (screenWith / 2) - 40, width: screenWith - 40, height: screenHeigth - (screenWith / 2))
            }
        }
        func closeAlert(){
            UIView.animate(withDuration: 1.0) {
                self.parentView.frame = CGRect(x: screenHeigth + 100, y: (screenWith / 2), width: screenWith - 40, height: screenHeigth - 40)
            }
        }
       @objc func doneButtonTapped(){
           closeAlert()
            UserDefaults.standard.set(true, forKey: "userLogin")
            UserDefaults.standard.synchronize()
        }
}
