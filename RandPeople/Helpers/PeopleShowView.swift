//
//  PeopleShowView.swift
//  RandPeople
//
//  Created by Mac on 1.09.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
//import Firebase
//import SVProgressHUD

class PeopleShowView: UIView{
    
    static let instance = PeopleShowView()
    private var anaview = UIView()
    private var imageView = UIImageView()
    private var closeButton = UIButton()
    private var confirmButton = UIButton()
    private var changeButton = UIButton()
    private var parentView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    @objc func closeediting(){
        self.parentView.endEditing(true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Error occur show alerView")
    }
    private func setUpView(){
        parentView = {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: screenWith, height: screenHeigth)
            view.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
            return view
        }()
        anaview = {
            let view = UIView()
            view.frame = CGRect(x: 20, y:40 , width: screenWith - 40, height: screenHeigth - 80)
            view.backgroundColor = .white
            return view
        }()
        confirmButton = {
            let button = UIButton()
            button.setTitle("Mesaja geç", for: .normal)
            button.backgroundColor = UIColor(red:0.40, green:0.83, blue:0.43, alpha:1.0)
            button.addTarget(self, action: #selector(PeopleShowView.directToMessage), for: .touchUpInside)
            return button
        }()
//        changeButton = {
//           let button = UIButton()
//            button.setTitle("Değiştir", for: .normal)
//            button.backgroundColor = .red
//            return button
//        }()
        closeButton = {
            let button = UIButton()
            button.frame = CGRect(x: anaview.frame.size.width - 50, y: 10, width: 35, height: 35)
            button.addTarget(self, action: #selector(PeopleShowView.closeTapped), for: .touchUpInside)
            button.setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
            return button
        }()
        imageView = {
           let imageView = UIImageView()
           imageView.frame = CGRect(x: 0, y: 0, width: anaview.frame.size.width, height: anaview.frame.size.height)
            imageView.image = UIImage(named: "austin")
            imageView.contentMode = .scaleToFill
           return imageView
        }()
        confirmButton.frame = CGRect(x: 0, y: anaview.frame.size.height - 150, width: anaview.frame.size.width, height: 50)
//        changeButton.frame = CGRect(x: 0, y: anaview.frame.size.height - 140, width: anaview.frame.size.width, height: 50)
        self.anaview.addSubview(imageView)
        self.anaview.addSubview(confirmButton)
//        self.anaview.addSubview(changeButton)
        self.anaview.addSubview(closeButton)
        self.parentView.addSubview(anaview)
    }
    func showAlert()
    {
        UIApplication.shared.keyWindow?.addSubview(self.parentView)
    }
    func setImage(with:String){
        self.imageView.sd_setImage(with: URL(string: with), completed: nil)
    }
    @objc func closeTapped() {
        parentView.removeFromSuperview()
        // burada silme işlemi gerçekleşecek
    }
    @objc func directToMessage(){
        guard let appdel = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("error")
        }
        appdel.open_Page(withPage: .PersonalChatView)
    }
    
}
