//
//  ViewController.swift
//  RandPeople
//
//  Created by Mac on 1.09.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class Navbar: UIViewController {
    private var customNavBar = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        MasterPage()
    }
}
extension Navbar : CreateView{
    func MasterPage() {
        customNavBar = {
            let view = UIView()
            view.backgroundColor = UIColor(red:0.56, green:0.85, blue:0.82, alpha:1.0)
            return view
        }()
        
        customNavBar.frame = CGRect(x: 0, y: 0, width: screenWith, height: 85)
        self.view.addSubview(customNavBar)
    }
}

