//
//  SuspendUserInfoVC.swift
//  RandPeople
//
//  Created by Mac on 14.02.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class SuspendUserInfoVC: UIViewController {
    private var suspendedLabel : UILabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.suspendedLabel = {
              let lbl = UILabel()
              lbl.text = "Your account has been suspended"
              lbl.textAlignment = .center
              lbl.textColor = .red
              lbl.frame = CGRect(x: 0, y: (screenHeigth / 2) - 25, width: screenWith, height: 50)
              return lbl
        }()
        self.view.addSubview(self.suspendedLabel)
    }
}
