//
//  NoResultCell.swift
//  RandPeople
//
//  Created by Mac on 6.09.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import UIKit

class NoResultCell: UITableViewCell {
    
    var CommenterName: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let anaView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        view.frame = CGRect(x: 5, y: 0, width: screenWith - 10, height: 50)
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
        
        CommenterName.frame = CGRect(x: 0, y: 10, width: self.anaView.frame.size.width, height: 30)
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
