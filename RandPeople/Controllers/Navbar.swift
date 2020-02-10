//
//  ViewController.swift
//  RandPeople
//
//  Created by Mac on 1.09.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Firebase

class Navbar: UIViewController {
    private var customNavBar = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        MasterPage()
        if Reachability.isConnectedToNetwork() == false {
            self.present(CreateAlert.referance.createAlert(withTitle: "Informations", andMessage: "No internet connection", andActionTitle: "Okay")
            ,animated: true,completion: nil)
        }
    }
     func compareDate(withDate:Timestamp)->Bool{
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDateF = dateFormatter.string(from: currentDate)
        let comingDateF = dateFormatter.string(from: withDate.dateValue())
        print("CurrentDate: \(currentDateF)" )
        print("ComingDate: \(comingDateF)")
        if currentDateF ==  comingDateF{
            return false
        }else {
            return true
        }
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

