//
//  CreateAlert.swift
//  RandPeople
//
//  Created by Mac on 1.09.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import UIKit

class CreateAlert{
    
    static let referance = CreateAlert()
    private init(){
        
    }
    func createAlert(withTitle:String , andMessage:String ,andActionTitle:String)->UIAlertController{
        let alert = UIAlertController(title: withTitle, message: andMessage, preferredStyle: .alert)
        let Action = UIAlertAction(title: andActionTitle, style: .cancel, handler: nil)
        alert.addAction(Action)
        return alert
    }
}
