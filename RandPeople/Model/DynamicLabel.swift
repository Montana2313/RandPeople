//
//  DynamicLabel.swift
//  RandPeople
//
//  Created by Mac on 8.02.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit

class DynamicLabelSize {
    
    static func height(text: String?, font: UIFont, width: CGFloat) -> CGFloat {
        
        var currentHeight: CGFloat!
        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        currentHeight = label.frame.height
        label.removeFromSuperview()
        
        return currentHeight
    }
    
}
