//
//  FirstCell.swift
//  RandPeople
//
//  Created by Mac on 1.09.2019.
//  Copyright © 2019 Mac. All rights reserved.
//


import UIKit

class FirstCell: UITableViewCell {
    
    var CommenterName: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.backgroundColor = .clear
        lbl.numberOfLines = 0
        return lbl
    }()

    let anaView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.42, green:0.65, blue:0.61, alpha:1.0)
        
        view.frame = CGRect(x: 5, y: 0, width: screenWith - 5, height: 45)
        view.layer.cornerRadius = view.frame.width/25.0
        view.clipsToBounds = true
        
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        
        CommenterName.frame = CGRect(x: 10, y: 0, width: screenWith, height: 45)
        anaView.addSubview(CommenterName)
        
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

