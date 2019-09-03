//
//  MessagesCell.swift
//  RandPeople
//
//  Created by Mac on 1.09.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import UIKit

class MessagesCell: UITableViewCell {
    
    var userId : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "123QWE-EWR45*********"
        return label
    }()
    var uıimageView : UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "CameraButton")
        return imageview
    }()
    
    let anaView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.75, green:0.91, blue:0.87, alpha:1.0)
        view.frame = CGRect(x: 5, y: 0, width: screenWith - 10, height: 60.0)
        view.layer.cornerRadius = view.frame.width/30.0
        view.clipsToBounds = true
        
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        uıimageView.frame = CGRect(x: 10, y: 10, width: 45, height:40)
        userId.frame = CGRect(x: 70, y:10, width: screenWith - 140, height: 45)
        
        
        anaView.addSubview(uıimageView)
        anaView.addSubview(userId)
    
        self.addSubview(anaView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

